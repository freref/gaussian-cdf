// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

/// @title Implementation of Gaussian CDF function
/// @author freref
/// @notice Zelen & Severo approximation
library NormalDistribution {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    int256 internal constant WAD_INT = 1e18;
    int256 internal constant p = 2316419; // 0.2316419 * 1e7
    int256 internal constant b1 = 319381530; // 0.319381530 * 1e9
    int256 internal constant b2 = -356563782; // -0.356563782 * 1e9
    int256 internal constant b3 = 1781477937; // 1.781477937 * 1e9
    int256 internal constant b4 = -1821255978; // -1.821255978 * 1e9
    int256 internal constant b5 = 1330274429; // 1.330274429 * 1e9
    int256 internal constant SQRT_2_PI = 2506628274631000242; // sqrt(2 * pi) * 1e18

    function pdf(int256 x) internal pure returns (int256) {
        int256 exponent = x.sMulWad(x) / -2;
        exponent = exponent.expWad();
        return exponent.sDivWad(SQRT_2_PI);
    }

    function cdf(
        int256 x,
        int256 mu,
        int256 sigma
    ) internal pure returns (int256) {
        require(sigma > 0 && sigma <= 1e37, "InvalidSigma");
        require(mu >= -1e38 && mu <= 1e38, "InvalidMu");
        require(x >= -1e41 && x <= 1e41, "InvalidX");

        int256 z = ((x - mu) * WAD_INT) / sigma;

        if (z < -10 * WAD_INT) {
            return 0;
        }

        if (z > 10 * WAD_INT) {
            return WAD_INT;
        }

        if (z < 0) {
            return WAD_INT - cdf(-x, -mu, sigma);
        }

        int256 t = WAD_INT.sDivWad(WAD_INT + (p * z) / 1e7);
        int256 t2 = t.sMulWad(t);
        int256 t3 = t2.sMulWad(t);
        int256 t4 = t3.sMulWad(t);
        int256 t5 = t4.sMulWad(t);

        int256 pol = (t * b1) /
            1e9 +
            (t2 * b2) /
            1e9 +
            (t3 * b3) /
            1e9 +
            (t4 * b4) /
            1e9 +
            (t5 * b5) /
            1e9;

        int256 pdf_result = pdf(z);

        return WAD_INT - pdf_result.sMulWad(pol);
    }
}
