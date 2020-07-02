pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './IKyberNetworkProxy.sol';
import './IUniswap.sol';

contract Arbitrage {
  address kyberAddress = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
  address uniswapAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function runTokenKyberUniswap(
    uint amount, 
    address srcTokenAddress, 
    address dstTokenAddress
  ) onlyOwner() external {
    //Kyber srcToken => dstToken 
    //Uniswap dstToken => srcToken 
    IERC20 srcToken = IERC20(srcTokenAddress);
    IERC20 dstToken = IERC20(dstTokenAddress);
    srcToken.transfer(address(this), amount);

    //Kyber srcToken => dstToken 
    IKyberNetworkProxy kyber = IKyberNetworkProxy(kyberAddress);
    srcToken.approve(address(kyber), amount);
    (uint rate, ) = kyber.getExpectedRate(srcToken, dstToken, amount);
    kyber.swapTokenToToken(srcToken, amount, dstToken, rate);

    //Uniswap dstToken => srcToken 
    IUniswap uniswap = IUniswap(uniswapAddress);
    uint balanceDstToken = dstToken.balanceOf(address(this));
    dstToken.approve(address(uniswap), balanceDstToken);
    address[] memory path = new address[](2);
    path[0] = address(dstToken);
    path[1] = address(srcToken);
    uint[] memory minOuts = uniswap.getAmountsOut(balanceDstToken, path); 
    uniswap.swapExactTokensForTokens(
      balanceDstToken,
      minOuts[0], 
      path, 
      address(this), 
      now
    );
  }

  function runTokenUniswapKyber(uint amount, address srcTokenAddress, address dstTokenAddress) onlyOwner() external {
    //Kyber srcToken => dstToken 
    //Uniswap dstToken => srcToken 
    IERC20 srcToken = IERC20(srcTokenAddress);
    IERC20 dstToken = IERC20(dstTokenAddress);
    srcToken.transfer(address(this), amount);

    //Uniswap srcToken => dstToken 
    IUniswap uniswap = IUniswap(uniswapAddress);
    srcToken.approve(address(uniswap), amount);
    address[] memory path = new address[](2);
    path[0] = address(srcToken);
    path[1] = address(dstToken);
    uint[] memory minOuts = uniswap.getAmountsOut(amount, path); 
    uniswap.swapExactTokensForTokens(
      amount,
      minOuts[0], 
      path, 
      address(this), 
      now
    );

    //Kyber dstToken => srcToken
    IKyberNetworkProxy kyber = IKyberNetworkProxy(kyberAddress);
    uint balanceDstToken = dstToken.balanceOf(address(this));
    srcToken.approve(address(kyber), balanceDstToken);
    (uint rate, ) = kyber.getExpectedRate(dstToken, srcToken, balanceDstToken);
    kyber.swapTokenToToken(dstToken, balanceDstToken, srcToken, rate);
  }

  function withdrawETHAndTokens(address tokenAddress) external onlyOwner() {
    msg.sender.transfer(address(this).balance);
    IERC20 token = IERC20(tokenAddress);
    uint256 currentTokenBalance = token.balanceOf(address(this));
    token.transfer(msg.sender, currentTokenBalance);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'only owner');
    _;
  }

}
