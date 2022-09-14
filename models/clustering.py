import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs


class Clustering:
    def __init__(self, adj, alpha):
        self.adj = adj
        self.alpha = alpha

if __name__ == '__main__':
    num_nodes = 10
    num_clusters = 3

    dim_y = (10, 10)

    pos = 10*np.random.random((num_nodes, 2))

    X, labels = make_blobs(n_samples=num_nodes, n_features=2, centers=num_clusters, center_box=(1, 9), cluster_std=0.5)
    Y = np.random.random(dim_y)

    psi_y = dict()
    for i in range(num_nodes):
        psi_y[i] = np.ones(dim_y) * np.nan
        for x in range(10):
            for y in range(10):
                if np.linalg.norm(pos[i] - np.array([x, y])) <= 3:
                    psi_y[i][x][y] = Y[x][y] + 0.1 * (2 * np.random.rand() - 1)
