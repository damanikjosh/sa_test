from functools import reduce
import operator
from copy import deepcopy


def getFromDict(dataDict, mapList):
    return reduce(operator.getitem, mapList, dataDict)


def setInDict(dataDict, mapList, value):
    getFromDict(dataDict, mapList[:-1])[mapList[-1]] = value


class Sharing:
    NONE = -1
    MIN = 0
    MAX = 1
    AVG = 2
    CNT = 3

    def __init__(self):
        self.data = dict()
        self.type = dict()
        self.alpha = dict()

    def __getitem__(self, key):
        return self.data[key]

    def __setitem__(self, key, value):
        if not key in self.data:
            print('Key %s does not exist' % str(key))
            raise

        self.data[key] = deepcopy(value)

    def __delitem__(self, key):
        del self.data[key]
        del self.type[key]

    def add(self, key, data_type, alpha=0.5, data_init=None):
        ## TYPE
        # 0: Max consensus
        # 1: Min consensus
        # 2: Average consensus
        # 3: Count consensus
        self.data[key] = deepcopy(data_init) if data_init is not None else dict()
        self.type[key] = data_type
        self.alpha[key] = alpha
        pass

    def update(self, other):
        for key in self.data.keys():
            if isinstance(other.data[key], dict):

                obj_list = [other.data[key]]
                key_list = [list(other.data[key].keys())]
                curr_key = [-1]
                while obj_list:
                    if not key_list[-1]:
                        i = len(curr_key) - 1
                        while i >= 0 and not key_list[i]:
                            # print('aaa')
                            del obj_list[i]
                            del key_list[i]
                            del curr_key[i]
                            i -= 1
                        if i < 0:
                            break

                    curr_key[-1] = key_list[-1].pop(0)
                    curr_obj = obj_list[-1][curr_key[-1]]
                    # print(curr_key)
                    if isinstance(curr_obj, dict):
                        if not curr_key[-1] in getFromDict(self.data[key], curr_key[:-1]):
                            setInDict(self.data[key], curr_key, curr_obj)
                            # print('Skip')
                            continue
                        obj_list.append(curr_obj)
                        key_list.append(list(curr_obj.keys()))
                        curr_key.append(-1)
                    else:
                        if not curr_key[-1] in getFromDict(self.data[key], curr_key[:-1]):
                            setInDict(self.data[key], curr_key, curr_obj)

                        self_data = getFromDict(self.data[key], curr_key)

                        if self.type[key] == self.MIN:
                            setInDict(self.data[key], curr_key, min(self_data, curr_obj))
                        elif self.type[key] == self.MAX:
                            setInDict(self.data[key], curr_key, max(self_data, curr_obj))
                        elif self.type[key] == self.AVG:
                            setInDict(self.data[key], curr_key,
                                      1. * self.alpha[key] * self_data + (1. - self.alpha[key]) * curr_obj)
