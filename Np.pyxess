# neomind_np_practice.py

import random
from itertools import permutations, combinations, product
from copy import deepcopy

# -------------------------
# 1. TREASURE HUNT (Combinatorial Search)
# -------------------------
def generate_treasure_map(size=5, treasures=1):
    grid = [[0]*size for _ in range(size)]
    for _ in range(treasures):
        x, y = random.randint(0,size-1), random.randint(0,size-1)
        grid[x][y] = 1
    return grid

def solve_treasure_bruteforce(grid):
    size = len(grid)
    for x,y in product(range(size), repeat=2):
        if grid[x][y]==1:
            return [(x,y)]
    return []

def solve_treasure_heuristic(grid):
    size = len(grid)
    attempts = [(random.randint(0,size-1), random.randint(0,size-1)) for _ in range(size*size)]
    for x,y in attempts:
        if grid[x][y]==1:
            return [(x,y)]
    return []

def verify_treasure(grid, solution):
    return all(grid[x][y]==1 for x,y in solution)

# -------------------------
# 2. SUDOKU (Constraint Satisfaction)
# -------------------------
def generate_sudoku(grid_size=9, filled=20):
    """Generate a partial Sudoku puzzle (for demo)"""
    grid = [[0]*grid_size for _ in range(grid_size)]
    for _ in range(filled):
        x, y, val = random.randint(0,grid_size-1), random.randint(0,grid_size-1), random.randint(1,grid_size)
        grid[x][y] = val
    return grid

def sudoku_solver(grid):
    """Simple backtracking Sudoku solver"""
    size = len(grid)
    def is_safe(x,y,num):
        for i in range(size):
            if grid[x][i]==num or grid[i][y]==num:
                return False
        start_x, start_y = 3*(x//3), 3*(y//3)
        for i in range(3):
            for j in range(3):
                if grid[start_x+i][start_y+j]==num:
                    return False
        return True

    def solve():
        for i in range(size):
            for j in range(size):
                if grid[i][j]==0:
                    for num in range(1,size+1):
                        if is_safe(i,j,num):
                            grid[i][j]=num
                            if solve():
                                return True
                            grid[i][j]=0
                    return False
        return True

    solved_grid = deepcopy(grid)
    if solve():
        return solved_grid
    return None

def verify_sudoku(grid):
    size = len(grid)
    for i in range(size):
        if len(set(grid[i])) != size or len(set([grid[j][i] for j in range(size)])) != size:
            return False
    for x in range(0,size,3):
        for y in range(0,size,3):
            block = [grid[i][j] for i in range(x,x+3) for j in range(y,y+3)]
            if len(set(block)) != 9:
                return False
    return True

# -------------------------
# 3. TRAVELING SALESMAN (Combinatorial Optimization)
# -------------------------
def generate_tsp(n=5, max_distance=20):
    cities = list(range(n))
    distance_matrix = [[0 if i==j else random.randint(1,max_distance) for j in range(n)] for i in range(n)]
    return cities, distance_matrix

def solve_tsp_bruteforce(cities, dist):
    best_route = None
    best_cost = float('inf')
    for perm in permutations(cities):
        cost = sum(dist[perm[i]][perm[i+1]] for i in range(len(cities)-1))
        if cost < best_cost:
            best_cost = cost
            best_route = perm
    return best_route, best_cost

def verify_tsp(cities, route):
    return set(route) == set(cities)

# -------------------------
# 4. SUBSET SUM
# -------------------------
def generate_subset_sum(n=10, target=15):
    arr = [random.randint(1,10) for _ in range(n)]
    return arr, target

def solve_subset_sum(arr, target):
    for r in range(1,len(arr)+1):
        for comb in combinations(arr,r):
            if sum(comb)==target:
                return comb
    return None

def verify_subset_sum(arr, subset, target):
    return sum(subset)==target and all(x in arr for x in subset)

# -------------------------
# 5. FACTORING SMALL INTEGERS
# -------------------------
def generate_factor_problem(max_num=100):
    n = random.randint(10,max_num)
    return n

def solve_factors(n):
    factors = []
    for i in range(2,n+1):
        if n%i==0:
            factors.append(i)
    return factors

def verify_factors(n, factors):
    product = 1
    for f in factors:
        product *= f
    return product==n

# -------------------------
# 6. EVIDENCE LOGGER
# -------------------------
def record_evidence(problem_name, input_data, solution, method, verified):
    evidence = {
        "problem": problem_name,
        "input": input_data,
        "solution": solution,
        "method": method,
        "verified": verified
    }
    # In NeoMind, store locally or blockchain
    return evidence

# -------------------------
# 7. DEMONSTRATION
# -------------------------
if __name__ == "__main__":
    # Example Treasure Hunt
    treasure_map = generate_treasure_map(size=5)
    sol_bf = solve_treasure_bruteforce(treasure_map)
    verified = verify_treasure(treasure_map, sol_bf)
    evidence = record_evidence("Treasure Hunt", treasure_map, sol_bf, "Brute Force", verified)
    print("Treasure Hunt Evidence:", evidence)

    # Example Sudoku
    puzzle = generate_sudoku()
    sol = sudoku_solver(puzzle)
    verified = verify_sudoku(sol)
    evidence = record_evidence("Sudoku", puzzle, sol, "Backtracking", verified)
    print("Sudoku Evidence:", evidence)

    # Example TSP
    cities, dist = generate_tsp()
    route, cost = solve_tsp_bruteforce(cities, dist)
    verified = verify_tsp(cities, route)
    evidence = record_evidence("TSP", dist, route, "Brute Force", verified)
    print("TSP Evidence:", evidence)

    # Example Subset Sum
    arr, target = generate_subset_sum()
    subset = solve_subset_sum(arr, target)
    verified = verify_subset_sum(arr, subset, target)
    evidence = record_evidence("Subset Sum", arr, subset, "Exhaustive Search", verified)
    print("Subset Sum Evidence:", evidence)

    # Example Factoring
    n = generate_factor_problem()
    factors = solve_factors(n)
    verified = verify_factors(n, factors)
    evidence = record_evidence("Factoring", n, factors, "Exhaustive", verified)
    print("Factoring Evidence:", evidence)