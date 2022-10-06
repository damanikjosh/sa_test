import random

import matplotlib
import munkres
import numpy as np
import numpy.linalg as LA
import matplotlib.pyplot as plt
import matplotlib.animation as animation

matplotlib.use('TkAgg')

def clamp(angle):
    if angle > np.pi:
        angle -= 2 * np.pi
    elif angle < -np.pi:
        angle += 2 * np.pi
    return angle

class Agent():
    def __init__(self, agent_id, agent_type, x, y):
        self.id = agent_id
        self.type = agent_type
        self.x = x
        self.y = y
        self.pos = np.array([x, y])
        self.yaw = 0
        if self.type == 0:
            self.vel = 0.05
            self.max_ang = 10
        elif self.type == 1:
            self.vel = 0.2
            self.max_ang = 100
        self.phase = 0
        self.target = [0,0]
        self.save_pos = [x,y]
        self.waypoints = []
        self.task = -1
        self.task_type = -1
        self.capture = 0
        # Type 0 : USV일 때
        # phase 0 : 대기 혹은 복귀 - Base 로 복귀하도록 하고 Base 근처라면 멈춘다
        # phase 1 : 적군을 찾아간다 - Waypoint 를 따라 간다 (Waypoint 는 적군의 위치인데, 가는 길에 장애물(해안선)이 있으면 돌아간다)
        # phase 2 : 적군과 충분히 가까워지면 복귀한다

        # Type 1 : UAV 일 때
        # phase 0 : 대기 혹은 복귀 - Base 로 복귀하도록 하고 Base 근처라면 멈춘다
        # phase 1 : Search - Grid Point 를 무한히 재방문한다
        # phase 2 : Track - 적군을 따라다닌다

    def set_pos(self, pos):
        self.x = pos[0]
        self.y = pos[1]
        self.pos = np.array([self.x, self.y])

    def set_waypoint(self, wp):
        self.waypoints = wp
        self.target = wp[0]

    def set_target(self):
        if self.task_type == 0 or self.task_type == 3:
            tp = np.asarray(self.target) - np.asarray(self.pos)
            if LA.norm(tp) < self.vel:
                if len(self.waypoints) > 1:
                    self.waypoints.pop(0)
                    print("Set_target",self.type, self.id, self.waypoints)

    def move(self):
        diff = np.asarray(self.target) - self.pos
        ang = np.arctan2(diff[0], diff[1])
        # print(ang, self.yaw)
        ang_diff = max(min(clamp(ang - self.yaw), self.max_ang*np.pi/180), -self.max_ang*np.pi/180)

        if LA.norm(diff) > self.vel:
            dist = min(LA.norm(diff), self.vel)

            self.yaw += ang_diff
            self.yaw = clamp(self.yaw)
            # print(self.pos, np.array([np.sin(self.yaw*np.pi/180) * dist, np.cos(self.yaw*np.pi/180) * dist]))
            self.pos += np.array([np.sin(self.yaw) * dist, np.cos(self.yaw) * dist])
            # print(self.pos)
            self.x = self.pos[0]
            self.y = self.pos[1]
            # print(self.x)
            self.save_pos.append([self.x, self.y])

class Illegal_Agent():
    def __init__(self, agent_id, x, y):
        self.id = agent_id
        self.x = x
        self.y = y
        self.pos = np.array([x, y])
        self.yaw = 0
        self.vel = 0.03
        self.phase = 0
        self.fishing_time = 0
        self.target = [x, y]
        self.save_pos = [x, y]
        self.in_track = 0
        self.in_capture = 0

    # phase 0 : 조업하기 / phase 1 : USV 한테 발견되면 일단 도망 / phase 2 : 충분히 가까워지면 끌려가기
    def set_target(self, blue):
        if self.phase == 0:
            if self.fishing_time > 100:
                self.fishing_time = 0
                self.target = self.pos + [random.random()*2-1, random.random()*2-1]
            if LA.norm(np.asarray(self.target) - self.pos) < 0.05:
                self.fishing_time += 1
        elif self.phase == 1:
            self.target = -(blue - self.pos) + self.pos
        elif self.phase == 2:
            self.target = blue
            self.vel = 0.05

    def move(self):
        diff = np.asarray(self.target) - self.pos
        ang = np.arctan2(diff[0], diff[1])
        # print(ang, self.yaw)
        ang_diff = max(min(clamp(ang - self.yaw), 50*np.pi/180), -50*np.pi/180)

        if LA.norm(diff) > self.vel:
            dist = min(LA.norm(diff), self.vel)

            self.yaw += ang_diff
            self.yaw = clamp(self.yaw)
            # print(self.pos, np.array([np.sin(self.yaw*np.pi/180) * dist, np.cos(self.yaw*np.pi/180) * dist]))
            self.pos += np.array([np.sin(self.yaw) * dist, np.cos(self.yaw) * dist])
            # print(self.pos)
            self.x = self.pos[0]
            self.y = self.pos[1]
            # print(self.x)
            self.save_pos.append([self.x, self.y])

class Task():
    def __init__(self, type, wp, enemy):
        # type 0 : uav search / type 1 : uav track / type 2 : usv go / type 3 : usv back
        self.type = type
        self.wp = wp
        self.enemy = enemy

def gen_triangle(center, ang_):
    mat_ = np.zeros((4, 2))
    mat_[0] = [0.5 * np.sin(ang_ - np.pi / 2), 0.5 * np.cos(ang_ - np.pi / 2)] + center
    mat_[1] = [1.5 * np.sin(ang_), 1.5 * np.cos(ang_)] + center
    mat_[2] = [0.5 * np.sin(ang_ + np.pi / 2), 0.5 * np.cos(ang_ + np.pi / 2)] + center
    mat_[3] = [0.5 * np.sin(ang_ - np.pi / 2), 0.5 * np.cos(ang_ - np.pi / 2)] + center
    return mat_

class info():
    def __init__(self, Agents, I_Agents):
        self.Agents = Agents
        self.N_agents = len(Agents)
        self.N_agents0 = 0
        self.N_agents1 = 0
        self.N_tasks = 0
        self.I_Agents = I_Agents
        self.N_i_agents = len(I_Agents)
        self.Tasks = []
        self.UAV_base = [-5.0, -5.0]
        self.USV_base = [5.0, 0.0]
        self.trig = 0
        self.mat = []
        self.reward_mat = [[0, 0, 1000, 1000],[100, 1000, 0, 0]]
        for i in range(len(Agents)):
            if Agents[i].type == 0:
                self.Agents[i].set_pos(self.USV_base)
                self.Agents[i].target = self.USV_base
                self.N_agents0 += 1
            elif Agents[i].type == 1:
                self.Agents[i].set_pos(self.UAV_base)
                self.Agents[i].target = self.UAV_base
                self.N_agents1 += 1

        self.fig = plt.figure()
        self.ax = plt.axes(xlim=(-16, 16), ylim=(-16, 16))
        self.line = []
        for i in range(len(Agents)):
            if self.Agents[i].type == 0:
                l1, = self.ax.fill([Agents[i].x-0.5, Agents[i].x+0, Agents[i].x+0.5],
                                   [Agents[i].y+0, Agents[i].y+1.5, Agents[i].y+0], 'b', lw=2)
            else:
                l1, = self.ax.fill([Agents[i].x - 0.5, Agents[i].x + 0, Agents[i].x + 0.5],
                                   [Agents[i].y + 0, Agents[i].y + 1.5, Agents[i].y + 0], 'g', lw=2)
            self.line.append(l1)
        for i in range(len(I_Agents)):
            l2, = self.ax.fill([I_Agents[i].x-1.5, I_Agents[i].x+1, I_Agents[i].x+1.5],
                               [I_Agents[i].y+0, I_Agents[i].y+1.5, I_Agents[i].y+0], 'r', lw=2)
            self.line.append(l2)

    def gen_task(self):
        # type 0 : uav search / type 1 : uav track / type 2 : usv go / type 3 : usv back
        if self.trig == 0: # Initial condition
            print("Trig == 0")
            self.Tasks = []
            # waypoint generation for UAV Search
            for i in range(self.N_agents1):
                self.Tasks.append(Task(0, [[-15+ i*30/self.N_agents1, 0], [-15+(i+1)*30/self.N_agents1, 1],
                                           [-15+ i*30/self.N_agents1, 2], [-15+(i+1)*30/self.N_agents1, 3],
                                           [-15+ i*30/self.N_agents1, 4], [-15+(i+1)*30/self.N_agents1, 5],
                                           [-15+ i*30/self.N_agents1, 6], [-15+(i+1)*30/self.N_agents1, 7]], -1))
            self.trig = -1
            self.N_tasks = len(self.Tasks)

        elif self.trig == 1: # When UAV meet Illegal agent
            print("Trig == 1")
            for i in range(self.N_agents):
                print(self.Agents[i].type, self.Agents[i].pos, self.Agents[i].task_type)
            self.new_Tasks = []
            for i in range(self.N_tasks):
                if self.Tasks[i].type == 3:
                    self.new_Tasks.append(self.Tasks[i])
            self.Tasks = self.new_Tasks
            tp_ind = []
            tp_mat = []
            # Check how many UAV meet Illegal agent
            for i in range(self.N_i_agents):
                tp_mat.append([])
                for j in range(self.N_agents):
                    if self.Agents[j].type == 1:
                        tp_mat[i].append(LA.norm(self.Agents[j].pos - self.I_Agents[i].pos))
                if min(tp_mat[i]) < 1:
                    tp_ind.append(i)
            # UAV Search task insert
            tp_num = self.N_agents1 - len(tp_ind)
            for i in range(tp_num):
                self.Tasks.append(Task(0, [[-15+ i*30/tp_num, 0], [-15+(i+1)*30/tp_num, 1],
                                           [-15+ i*30/tp_num, 2], [-15+(i+1)*30/tp_num, 3],
                                           [-15+ i*30/tp_num, 4], [-15+(i+1)*30/tp_num, 5],
                                           [-15 + i * 30 / tp_num, 6], [-15 + (i + 1) * 30 / tp_num, 7]
                                           ], -1))
            # UAV Track task generation
            for i in range(len(tp_ind)):
                self.Tasks.append(Task(1, [self.I_Agents[tp_ind[i]].x, self.I_Agents[tp_ind[i]].y], tp_ind[i]))
            # USV Go task generation
            for i in range(len(tp_ind)):
                self.Tasks.append(Task(2, [self.I_Agents[tp_ind[i]].x, self.I_Agents[tp_ind[i]].y], tp_ind[i]))

            self.trig = -1
            self.N_tasks = len(self.Tasks)
            print(self.N_tasks)

        elif self.trig == 2:  # When USV meet Illegal agent
            print("Trig == 2")
            for i in range(self.N_agents):
                print(self.Agents[i].type, self.Agents[i].pos, self.Agents[i].task_type)
            self.Tasks = []
            tp_ind = []
            tp_mat = []
            # Check how many USV meet Illegal agent
            for i in range(self.N_i_agents):
                tp_mat.append([])
                for j in range(self.N_agents):
                    if self.Agents[j].type == 0:
                        tp_mat[i].append(LA.norm(self.Agents[j].pos - self.I_Agents[i].pos))
                if min(tp_mat[i]) < 1:
                    tp_ind.append(i)

            # UAV Search task insert
            tp_num = self.N_agents1
            for i in range(tp_num):
                self.Tasks.append(Task(0, [[-15 + i * 30 / tp_num, 0], [-15 + (i + 1) * 30 / tp_num, 1],
                                           [-15 + i * 30 / tp_num, 2], [-15 + (i + 1) * 30 / tp_num, 3],
                                           [-15 + i * 30 / tp_num, 4], [-15 + (i + 1) * 30 / tp_num, 5],
                                           [-15 + i * 30 / tp_num, 6], [-15 + (i + 1) * 30 / tp_num, 7]], -1))
            # USV Back task generation
            for i in range(len(tp_ind)):
                tp_pt = (self.USV_base - self.I_Agents[tp_ind[i]].pos)*0.2 + self.I_Agents[tp_ind[i]].pos
                print(self.I_Agents[tp_ind[i]].pos, tp_pt, self.USV_base)
                self.Tasks.append(Task(3, [[tp_pt[0], tp_pt[1]],[self.USV_base[0], self.USV_base[1]]], []))

            self.trig = -1
            self.N_tasks = len(self.Tasks)
            print(self.N_tasks)


    def gen_mat(self):
        self.mat = []
        for i in range(self.N_agents):
            self.mat.append([])
            for j in range(self.N_tasks):
                if len(self.Tasks[j].wp) > 1:
                    self.mat[i].append(LA.norm(self.Agents[i].pos - self.Tasks[j].wp[0])
                                       - self.reward_mat[self.Agents[i].type][self.Tasks[j].type] + 1000)
                elif len(self.Tasks[j].wp) == 1:
                    self.mat[i].append(LA.norm(self.Agents[i].pos - self.Tasks[j].wp)
                                       - self.reward_mat[self.Agents[i].type][self.Tasks[j].type] + 1000)
                else:
                    print("Before Gen_Task, Gen_cost_mat is executed")

    def task_assign(self):
        for i in range(self.N_agents):
            self.Agents[i].task = -1
            self.Agents[i].task_type = -1
        self.gen_mat()
        m = munkres.Munkres()
        indexes = m.compute(self.mat)
        for i in range(len(indexes)):
            self.Agents[indexes[i][0]].task = indexes[i][1]
            self.Agents[indexes[i][0]].task_type = self.Tasks[indexes[i][1]].type
        print(indexes)

    def ani_init(self):
        return self.line

    def ani_update(self, i):
        # Check how many UAV meet Illegal agent
        for i in range(self.N_agents):
            if (self.Agents[i].type == 1):
                for j in range(self.N_i_agents):
                    if (LA.norm(self.Agents[i].pos - self.I_Agents[j].pos) < 1):
                        if not self.Agents[i].task_type == 1:
                            if self.I_Agents[j].in_track == 0:
                                self.trig = 1

        # Check how many USV meet Illegal agent
        for i in range(self.N_agents):
            if (self.Agents[i].type == 0) & (not self.Agents[i].task_type == 3):
                for j in range(self.N_i_agents):
                    if (LA.norm(self.Agents[i].pos - self.I_Agents[j].pos) < 1):
                        if self.I_Agents[j].in_capture == 0 & self.Agents[i].capture == 0:
                            if LA.norm(self.Agents[i].pos - self.USV_base) > 1:
                                self.trig = 2

        if not self.trig == -1:
            self.gen_task()
            self.task_assign()

        N = len(self.Agents)
        for j in range(N):
            if self.Agents[j].task_type == 0:
                self.Agents[j].set_waypoint(self.Tasks[self.Agents[j].task].wp)
            elif self.Agents[j].task_type == 1:
                self.Tasks[self.Agents[j].task].wp = [self.I_Agents[self.Tasks[self.Agents[j].task].enemy].pos]
                self.Agents[j].set_waypoint(self.Tasks[self.Agents[j].task].wp)
                if LA.norm(self.I_Agents[self.Tasks[self.Agents[j].task].enemy].pos - self.Agents[j].pos) < 1:
                    self.I_Agents[self.Tasks[self.Agents[j].task].enemy].in_track = 1
            elif self.Agents[j].task_type == 2:
                self.Tasks[self.Agents[j].task].wp = [self.I_Agents[self.Tasks[self.Agents[j].task].enemy].pos]
                self.Agents[j].set_waypoint(self.Tasks[self.Agents[j].task].wp)
                if LA.norm(self.I_Agents[self.Tasks[self.Agents[j].task].enemy].pos - self.Agents[j].pos) < 1:
                    self.Agents[j].capture = 1
                    self.I_Agents[self.Tasks[self.Agents[j].task].enemy].in_capture = 1
            elif self.Agents[j].task_type == 3:
                self.Agents[j].set_waypoint(self.Tasks[self.Agents[j].task].wp)

        for j in range(N):
            self.Agents[j].set_target()
            self.Agents[j].move()
            # print(j)
            self.line[j].set_xy(gen_triangle(self.Agents[j].pos, self.Agents[j].yaw))

        for j in range(len(self.I_Agents)):
            if self.I_Agents[j].phase == 0:
                tp = []
                for k in range(self.N_agents):
                    if self.Agents[k].type == 0:
                        tp.append(LA.norm(self.Agents[k].pos - self.I_Agents[j].pos))
                if min(tp) < 3:
                    self.I_Agents[j].phase = 1
            elif self.I_Agents[j].phase == 1:
                tp = []
                for k in range(self.N_agents):
                    if self.Agents[k].type == 0:
                        tp.append(LA.norm(self.Agents[k].pos - self.I_Agents[j].pos))
                if min(tp) < 1:
                    self.I_Agents[j].phase = 2
            if self.I_Agents[j].phase == 0:
                self.I_Agents[j].set_target([])
            else:
                tp = []
                tp_ind = []
                for k in range(self.N_agents):
                    if self.Agents[k].type == 0:
                        tp_ind.append(k)
                        tp.append(LA.norm(self.Agents[k].pos - self.I_Agents[j].pos))
                self.I_Agents[j].set_target(self.Agents[tp_ind[np.argmin(tp)]].pos)
            self.I_Agents[j].move()

            tp = []
            for k in range(len(self.Agents)):
                if self.Agents[k].type == 1:
                    tp.append(LA.norm(self.I_Agents[j].pos - self.Agents[k].pos))
            self.line[N+j].set_xy(gen_triangle(self.I_Agents[j].pos, self.I_Agents[j].yaw))



        return self.line

    def animate(self):
        self.anim = animation.FuncAnimation(self.fig, self.ani_update, init_func=self.ani_init, frames=50, interval=20, blit=False)
        plt.show(block=True)

Agents = []
I_Agents = []
Agents.append(Agent(0,0,0.0,0.0))
Agents.append(Agent(1,0,0.0,0.0))
Agents.append(Agent(2,1,0.0,0.0))
Agents.append(Agent(3,1,0.0,0.0))
Agents.append(Agent(4,1,0.0,0.0))
I_Agents.append(Illegal_Agent(0,5.0,5.0))
I_Agents.append(Illegal_Agent(0,-5.0,5.0))


# Tasks.append(Task(0,0,[[-15,0],[-5,1],[-15,2],[-5,3]]))
# Tasks.append(Task(1,0,[[-5,0],[5,1],[-5,2],[5,3]]))
# Tasks.append(Task(2,0,[[5,0],[15,1],[5,2],[15,3]]))
info(Agents,I_Agents).animate()