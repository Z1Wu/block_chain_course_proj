# WelfareLottry

// todo 添加可以伸缩的 toc 

## How To Use

### 直接连上已经部署好的区块链...
// todo

## 本地重新构建开发环境

### 从github 拉取仓库

```shell
git clone <仓库地址>
```

### 配置私有链

有以下几种方式可以构建私有链

#### 使用truffle development

// todo 

#### 使用ganache 

// todo

#### 使用geth构建私有链

1. 安装geth，初始化私有链

geth 的安装可以去官网下载，在`geth-config`中含有对应的配置区块链的文件`genesis.json`。

``` shell

geth init 

```

2. 使用私有链的在发现交易的时候自动交易的脚本, 仓库中有一个样本可以在 `geth_config` 中找到 

``` js

```

3. 运行节点

### 修改 migrations文件内的内容

按照官方文档的解释，这个文件夹中的文件是用来将solidity 源代码部署到去对应的区块链上的代码，本项目只用到了最基本的部署，高级用法请看官网文档。

### 配置truffle-config.js

这里面需要配置对`

### 部署合约到私有链上

``` shell
truffle migrate --reset
```

### 

## 基本组成

### 管理者（Manager）

- 开奖页面

    - 展示现在的游戏轮数 => round_num
    
    - 开启新的游戏 =》 new_game

    - 开奖

- 添加新的受助者

    - 增加/更新受助者以及其可以领取的金额

### 参与者（Player）

- 输入金额进行投注。

- 查看奖池的数目

### 受助者

一个页面输入需要领取的金额数目，领取对应的金额
