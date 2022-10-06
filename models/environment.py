import pandas as pd
import numpy as np


class Obj:
    def __init__(self, raw):
        self.id = int(raw['id_obj'].iloc[0])
        self.obj_sea = bool(raw['Obj_Sea'].iloc[0])
        self.obj_air = bool(raw['Obj_Air'].iloc[0])
        self.obj_land = bool(raw['Obj_Land'].iloc[0])
        self.location_poly = raw[['Location_Poly_X', 'Location_Poly_Y']].dropna().values.tolist()
        self.location_point = raw[['Location_Point_X', 'Location_Point_Y']].dropna().values.tolist()
        self.density = float(raw['Density'].iloc[0])
        self.wind_speed = float(raw['WindSpeed'].iloc[0])
        self.wind_dir = float(raw['WindDirectionDegree'].iloc[0])


class Agent:
    def __init__(self, raw):
        self.id = int(raw[0])
        self.type = int(raw[1])
        self.base = int(raw[2])
        self.gear1 = bool(raw[3])
        self.gear2 = bool(raw[4])
        self.gear3 = bool(raw[5])
        self.gear4 = bool(raw[6])
        self.location = [float(raw[7]), float(raw[8])]
        self.speed = float(raw[9])
        self.energy_consumption = float(raw[10])
        self.remain_energy = float(raw[11])
        self.mine_check_prob = float(raw[12])

    def __repr__(self):
        return '[%d: (%.2f, %.2f)]' % (self.id, self.location[0], self.location[1])


class Base:
    def __init__(self, raw):
        self.id = int(raw[0])
        self.location = [float(raw[1]), float(raw[2])]
        self.is_sea = bool(raw[3])
        self.is_air = bool(raw[4])
        self.is_land = bool(raw[5])

    def __repr__(self):
        return '[%d: (%.2f, %.2f)]' % (self.id, self.location[0], self.location[1])


class Node:
    def __init__(self, id, location):
        self.id = id
        self.location = location

    def __repr__(self):
        return '[%d: (%.2f, %.2f)]' % (self.id, self.location[0], self.location[1])

    def dist_to(self, other):
        return np.sqrt((self.location[0] - other.location[0]) ** 2 + (self.location[1] - other.location[1]) ** 2)


num_obj1 = (sum(1 for _ in open('../data/M3/LikeMineSweep/Obj_1.csv')) - 1) // 11
obj1_raw = [pd.read_csv('../data/M3/LikeMineSweep/Obj_1.csv', skiprows=i * 11 + 1, nrows=11, index_col=0, header=None).T for i in range(num_obj1)]
obj1 = [Obj(o) for o in obj1_raw]

num_obj2 = (sum(1 for _ in open('../data/M3/LikeMineSweep/Obj_2.csv')) - 1) // 11
obj2_raw = [pd.read_csv('../data/M3/LikeMineSweep/Obj_2.csv', skiprows=i * 11 + 1, nrows=11, index_col=0, header=None).T for i in range(num_obj2)]
obj2 = [Obj(o) for o in obj2_raw]

num_obj3 = (sum(1 for _ in open('../data/M3/LikeMineSweep/Obj_3.csv')) - 1) // 11
obj3_raw = [pd.read_csv('../data/M3/LikeMineSweep/Obj_3.csv', skiprows=i * 11 + 1, nrows=11, index_col=0, header=None).T for i in range(num_obj3)]
obj3 = [Obj(o) for o in obj3_raw]

num_obj4 = (sum(1 for _ in open('../data/M3/LikeMineSweep/Obj_4.csv')) - 1) // 11
obj4_raw = [pd.read_csv('../data/M3/LikeMineSweep/Obj_4.csv', skiprows=i * 11 + 1, nrows=11, index_col=0, header=None).T for i in range(num_obj4)]
obj4 = [Obj(o) for o in obj4_raw]

agents_raw = pd.read_csv('../data/M3/LikeMineSweep/Agent.csv').values.tolist()
num_agents = len(agents_raw)
agents = [Agent(agents_raw[i]) for i in range(num_agents)]

bases_raw = pd.read_csv('../data/M3/LikeMineSweep/Base.csv').values.tolist()
num_bases = len(bases_raw)
bases = [Base(bases_raw[i]) for i in range(num_bases)]

search_nodes = []
id = 0
for obj in obj1:
    for point in obj.location_point:
        search_nodes.append(Node(id, point))
        id += 1

pollution_nodes = []
id = 0
for obj in obj2:
    for point in obj.location_point:
        pollution_nodes.append(Node(id, point))
        id += 1

source_nodes = []
id = 0
for obj in obj4:
    for point in obj.location_point:
        source_nodes.append(Node(id, point))
        id += 1