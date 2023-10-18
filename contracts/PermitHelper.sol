// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./TRC25.sol";

interface IERC20Permit {
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
}

interface IERC721Permit {
    function permit(address spender, uint256 tokenId, uint256 deadline, bytes memory sig) external;
}

contract PermitHelper is TRC25 {
    constructor(string memory name_, string memory symbol_, uint8 decimals_) public TRC25(name_, symbol_, decimals_) {
    }

    function permitERC20(
        address token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        uint256 fee = estimateFee(0);
        _chargeFeeFrom(msg.sender, address(0), fee);
        IERC20Permit(token).permit(owner, spender, value, deadline, v, r, s);
    }

    function permitERC721(
        address collection,
        address spender,
        uint256 tokenId,
        uint256 deadline,
        bytes memory signature
    ) external {
        uint256 fee = estimateFee(0);
        _chargeFeeFrom(msg.sender, address(0), fee);
        IERC721Permit(collection).permit(spender, tokenId, deadline, signature);
    }

    function _estimateFee(uint256) internal view override returns (uint256) {
        return minFee();
    }
}
