# WelfareLottry

// todo 添加可以伸缩的 toc 



## 如何使用

### 直接连上已经部署好合约的区块链(testnet)

// todo 暂定采用  res testnet

## 本地重新构建开发环境

### 从github 拉取仓库

```shell
git clone <仓库地址>
```

### 安装 truffle 

[truffle官网]()有详细的教程

### 配置私有链

有以下几种方式可以构建私有链

#### 使用truffle development

// 详情查看官方文档

#### 使用ganache 

// 详情查看官方文档

#### 使用geth构建私有链

1. 安装geth，初始化私有链

geth 的安装可以去官网下载，在`geth-config`文件夹中含有对应的配置区块链的文件`genesis.json`。

``` shell
geth init <your_gensisi.json> 
```

2. 使用私有链的在发现交易的时候自动交易的脚本, 仓库中有一个样例代码，可以在 `geth_config` 文件夹中找到 `auto-mining.js`。

3. 运行节点

按照geth的文档，运行节点的，需要注意的在运行的时候打开对应的选项比如 `rpc` 和 `cors`， 具体可以参考 `run_geth.sh`。

``` shell

# 使用 run_geth.sh 运行节点
./run_geth.sh [想要节点运行的ip，默认是运行在localhost]

```


### 修改 migrations文件内的内容

按照官方文档的解释，这个文件夹中的文件是用来将solidity 源代码部署到去对应的区块链上的代码，本项目只用到了最基本的部署，高级用法请看官网文档。

### 配置truffle-config.js

本项目只配置了简单的配置了网络，以及生成 build的文件的位置。

### 部署合约到私有链上

``` shell
# 没有使用 reset 的话可能会出现 out-of-gas, 原因暂时不明白
truffle migrate --reset
```

### 在浏览器安装 metamask  

metamask 可以在`chrom store` 中找到，直接安装即可。

### 配置 metamask

在本地节点建立用户，之后将用户导入对应 metamask 中。

- 通过私钥导入用户，这个方法比较直观，直接把账户的私钥输入，之后就能通过 `metamask` 操作这个账户。
- 通过 geth 中的 `keystore`文件导入，实际上我们可以看到，在使用这种方法的时候，会提示需要输入密码，这个密码就是在 geth 节点中使用 `personal.newAccount` 创建账户的时候使用的密码。

在本地打开 keystore 中的 `utc-***.json`我们可以发现，实际上两种方法都是一样的，这个文件实际上使用了加密算法(aes) 。

 

### 本地搭建简单服务器运行前端代码

``` shell 

# in directory of vue-client-lite, then run 

npm install && npm run serve


```

## 应用基本组成

### 基本组件

- 状态栏

    - 当前已经进行游戏的轮数
    - 是否存在游戏进行
    - 当前奖池的数目

- 刷新按钮 =》 点击之后可以更新状态栏的状态

### 管理者（Manager）

- 游戏管理

    - 开启新的游戏 =》 new_game，开启新的游戏

    - 开奖 =》reveal,通过管理者运行的开奖函数

- 添加新的受助者

    - 增加/更新受助者以及其可以领取的金额

    - 查看当前可以领取的救助金的数额

### 参与者（Player）

- 输入金额进行投注 =》 bet

- 查看往期的开奖情况 =》 search

### 受助者（Recipient）

一个页面输入需要领取的金额数目，领取对应的金额

## 测试

### 测试条件说明

- 测试环境

    - 使用 `geth` 搭建的私有链 + `metamask` 

- 测试用户

    - 一个`Manager` 用于创建游戏和管理福利资金（抽取游戏中的手续费）
    - 两个`Player`, 用于在管理者创建的游戏中进行投注。
    - 一个 `Recipient` ，由于领取分配的救助金。

### 测试过程：

#### Manager 创建一个新的游戏



#### Player1进行投注

#### Player2进行投注

#### Manager 执行 `Reveal` 进行开奖

#### Manager 将就Recipient 添加到受助者名单中

#### Recipient 领取救助金





## 缺陷

- 开奖过程的优化(todo)。

- 过于粗糙的UI设计


## 参考

- [truffle 官方文档]()

- [如何实现真的随机数]

