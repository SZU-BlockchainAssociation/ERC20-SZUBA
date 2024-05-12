# ERC20
**ERC20是以太坊上的代币标准，实现了转账的基本逻辑。**

有关ERC20的具体介绍见 https://github.com/AmazingAng/WTF-Solidity/tree/main/31_ERC20

参考了[OpenZeppelin的实现逻辑](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20)

使用[foundry](https://learnblockchain.cn/docs/foundry/i18n/zh/forge/advanced-testing.html)在本地Anvil链上进行了部署，发行了符号为SZU的代币，并完成了单元测试（覆盖率100%）