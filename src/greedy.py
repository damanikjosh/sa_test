import logging

import matplotlib
import numpy as np
from matplotlib.animation import FuncAnimation
from scipy.spatial import KDTree

from models.environment import search_nodes, source_nodes, agents
from models.sharing import Sharing

logging.basicConfig(level=logging.DEBUG)

matplotlib.use('TkAgg')


# ------------------------------------------------------------
# Vehicle class object
# ------------------------------------------------------------
# This object must have the following properties:
# id        : Vehicle id (in integer)
# location  : Current location of vehicle
# base      : The starting and terminal location of vehicle
# type      : Vehicle type (1: UAV, 2: UGV)
# waypoint  : Target location
# mission   : Current task id that is performing
# speed     : Yeah
#
class Vehicle:

    # Initial function: performed once initial
    def __init__(self, id, init_pos, type):
        self.id = id
        self.location = init_pos
        self.base = init_pos
        self.type = type
        self.data = Sharing()

        self.waypoint = self.base
        self.mission = None
        self.speed = 0.5

        # ----------------------------------------------------
        # TODO: Put vehicle's variable here
        # ----------------------------------------------------
        self.data.add('task_type', Sharing.AVG)
        self.data.add('task_location', Sharing.AVG)
        self.data.add('task_assigned', Sharing.MAX)
        self.data.add('task_done', Sharing.MAX)

    # Step function: performed every time step
    def step(self, time):

        # If the vehicle is not conducting a mission or the task is already done, find new task
        if self.mission is None or (self.mission and self.data['task_done'][self.mission]):
            next_task = self.find_task(time)

            # If there is no task, go back to base
            if not next_task:
                self.waypoint = self.base
                self.mission = None

            # ----------------------------------------------------
            # TODO: Change behavior when task is assigned
            # ----------------------------------------------------
            else:
                self.mission = next_task
                self.waypoint = list(self.data['task_location'][next_task].values())

                self.data['task_assigned'][next_task] = 1

        # Move vehicle to its waypoint
        dist = self.dist_to(self.waypoint)
        if dist > self.speed:
            self.location += self.speed * np.subtract(self.waypoint, self.location) / dist
        else:
            self.location = self.waypoint
            self.arrived(time)

    # Function to calculate distance of a point to current location
    def dist_to(self, point):
        return np.linalg.norm(np.subtract(point, self.location))

    # ----------------------------------------------------
    # Function to perform when agent arrived at waypoint
    # TODO: Change behavior of agent when arrived at task
    # ----------------------------------------------------
    def arrived(self, time):
        if self.mission:
            self.data['task_done'][self.mission] = 1
            self.mission = None

    # Function to perform consensus with other vehicles
    def consensus(self, other):
        other.data.update(self.data)

    # ----------------------------------------------------
    # Task assignment function
    # TODO: Put your task assignment algorithm here
    # ----------------------------------------------------
    def find_task(self, time):
        available_tasks = [task_id for task_id, task_done in self.data['task_done'].items() if
                           not task_done and self.data['task_type'][task_id] == self.type and not
                           self.data['task_assigned'][task_id]]
        if available_tasks:
            tree = KDTree(
                [[self.data['task_location'][task_id][0], self.data['task_location'][task_id][1]] for task_id in
                 available_tasks])
            _, idx = tree.query([self.location[0], self.location[1]])
            return available_tasks[idx]
        return None


def loop(time):
    for vehicle in vehicles:
        vehicle.step(time)
        for other in vehicles:
            if vehicle.id == other.id:
                continue
            vehicle.consensus(other)

        for node in source_nodes:
            if 1000 + node.id not in vehicle.data['task_type']:
                # ----------------------------------------------------
                # Add pollution source task when detected by agents
                # TODO: Change behavior when pollution source is detected
                # ----------------------------------------------------
                if vehicle.dist_to(node.location) <= 5:
                    vehicle.data['task_type'][1000 + node.id] = 2
                    vehicle.data['task_location'][1000 + node.id] = {0: node.location[0], 1: node.location[1]}
                    vehicle.data['task_done'][1000 + node.id] = 0
                    vehicle.data['task_assigned'][1000 + node.id] = 0

        if vehicle.waypoint:
            agent_waypoint[vehicle.id].set_data([vehicle.location[0], vehicle.waypoint[0]],
                                                [vehicle.location[1], vehicle.waypoint[1]])
        else:
            agent_waypoint[vehicle.id].set_data([], [])
        agent_pos[vehicle.id].set_data(vehicle.location[0], vehicle.location[1])

    return tuple(list(agent_waypoint.values()) + list(agent_pos.values()))


if __name__ == '__main__':
    agent_pos = dict()
    agent_waypoint = dict()

    vehicles = []

    for agent in agents:
        vehicle = Vehicle(agent.id, agent.location, agent.type)
        for node in search_nodes:
            n = len(vehicle.data['task_type'])
            vehicle.data['task_type'][n] = 1
            vehicle.data['task_location'][n] = {0: node.location[0], 1: node.location[1]}
            vehicle.data['task_done'][n] = 0
            vehicle.data['task_assigned'][n] = 0
        vehicles.append(vehicle)


    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(1)
    ax.set_xlim((0, 100))
    ax.set_ylim((0, 100))
    colors = 'cbgrcmyk'

    for node in search_nodes:
        ax.scatter(node.location[0], node.location[1], color='0.9')
    for node in source_nodes:
        ax.scatter(node.location[0], node.location[1], marker='x', color='red')
    for vehicle in vehicles:
        agent_waypoint[vehicle.id], = ax.plot([], [], color=colors[vehicle.id % len(colors)], marker='.')
        agent_pos[vehicle.id], = ax.plot(vehicle.location[0], vehicle.location[1],
                                         color=colors[vehicle.id % len(colors)], marker='o')

    ani = FuncAnimation(fig, func=loop, frames=np.arange(1, 10000), blit=True, repeat=False, interval=0)
    plt.show()
