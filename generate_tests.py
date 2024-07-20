import numpy as np
from scipy.stats import norm


def float_to_fixed_point(value, decimal_places=18):
    scale_factor = 10**decimal_places
    return int(value * scale_factor)


def generate_test_cases(filename, num_cases=10000, decimal_places=18):
    with open(filename, "w") as f:
        for _ in range(num_cases):
            x = np.random.uniform(-1e23, 1e23)
            mu = np.random.uniform(-1e20, 1e20)
            sigma = np.random.uniform(1e-18, 1e19)  # Ensuring sigma > 0
            expected = norm.cdf(x, loc=mu, scale=sigma)

            x_fixed = float_to_fixed_point(x, decimal_places)
            mu_fixed = float_to_fixed_point(mu, decimal_places)
            sigma_fixed = float_to_fixed_point(sigma, decimal_places)
            expected_fixed = float_to_fixed_point(expected, decimal_places)

            f.write(f"{x_fixed},{mu_fixed},{sigma_fixed},{expected_fixed}\n")


if __name__ == "__main__":
    generate_test_cases("test_cases.txt")
