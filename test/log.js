Contract {
  currentProvider: [Getter/Setter],
  _requestManager: RequestManager {
    provider: HttpProvider {
      host: 'https://ropsten.infura.io/v3/2571ab4c0de14ffb87392fb9c3904375',
      httpsAgent: [Agent],
      timeout: 0,
      headers: undefined,
      connected: false
    },
    providers: {
      WebsocketProvider: [Function: WebsocketProvider],
      HttpProvider: [Function: HttpProvider],
      IpcProvider: [Function: IpcProvider]
    },
    subscriptions: {}
  },
  givenProvider: null,
  providers: {
    WebsocketProvider: [Function: WebsocketProvider],
    HttpProvider: [Function: HttpProvider],
    IpcProvider: [Function: IpcProvider]
  },
  _provider: HttpProvider {
    host: 'https://ropsten.infura.io/v3/2571ab4c0de14ffb87392fb9c3904375',
    httpsAgent: Agent {
      _events: [Object: null prototype],
      _eventsCount: 1,
      _maxListeners: undefined,
      defaultPort: 443,
      protocol: 'https:',
      options: [Object],
      requests: {},
      sockets: {},
      freeSockets: {},
      keepAliveMsecs: 1000,
      keepAlive: true,
      maxSockets: Infinity,
      maxFreeSockets: 256,
      maxCachedSessions: 100,
      _sessionCache: [Object]
    },
    timeout: 0,
    headers: undefined,
    connected: false
  },
  setProvider: [Function],
  BatchRequest: [Function: bound Batch],
  extend: [Function: ex] {
    formatters: {
      inputDefaultBlockNumberFormatter: [Function: inputDefaultBlockNumberFormatter],
      inputBlockNumberFormatter: [Function: inputBlockNumberFormatter],
      inputCallFormatter: [Function: inputCallFormatter],
      inputTransactionFormatter: [Function: inputTransactionFormatter],
      inputAddressFormatter: [Function: inputAddressFormatter],
      inputPostFormatter: [Function: inputPostFormatter],
      inputLogFormatter: [Function: inputLogFormatter],
      inputSignFormatter: [Function: inputSignFormatter],
      outputBigNumberFormatter: [Function: outputBigNumberFormatter],
      outputTransactionFormatter: [Function: outputTransactionFormatter],
      outputTransactionReceiptFormatter: [Function: outputTransactionReceiptFormatter],
      outputBlockFormatter: [Function: outputBlockFormatter],
      outputLogFormatter: [Function: outputLogFormatter],
      outputPostFormatter: [Function: outputPostFormatter],
      outputSyncingFormatter: [Function: outputSyncingFormatter]
    },
    utils: {
      _fireError: [Function: _fireError],
      _jsonInterfaceMethodToString: [Function: _jsonInterfaceMethodToString],
      _flattenTypes: [Function: _flattenTypes],
      randomHex: [Function: randomHex],
      _: [Function],
      BN: [Function],
      isBN: [Function: isBN],
      isBigNumber: [Function: isBigNumber],
      isHex: [Function: isHex],
      isHexStrict: [Function: isHexStrict],
      sha3: [Function],
      keccak256: [Function],
      soliditySha3: [Function: soliditySha3],
      isAddress: [Function: isAddress],
      checkAddressChecksum: [Function: checkAddressChecksum],
      toChecksumAddress: [Function: toChecksumAddress],
      toHex: [Function: toHex],
      toBN: [Function: toBN],
      bytesToHex: [Function: bytesToHex],
      hexToBytes: [Function: hexToBytes],
      hexToNumberString: [Function: hexToNumberString],
      hexToNumber: [Function: hexToNumber],
      toDecimal: [Function: hexToNumber],
      numberToHex: [Function: numberToHex],
      fromDecimal: [Function: numberToHex],
      hexToUtf8: [Function: hexToUtf8],
      hexToString: [Function: hexToUtf8],
      toUtf8: [Function: hexToUtf8],
      utf8ToHex: [Function: utf8ToHex],
      stringToHex: [Function: utf8ToHex],
      fromUtf8: [Function: utf8ToHex],
      hexToAscii: [Function: hexToAscii],
      toAscii: [Function: hexToAscii],
      asciiToHex: [Function: asciiToHex],
      fromAscii: [Function: asciiToHex],
      unitMap: [Object],
      toWei: [Function: toWei],
      fromWei: [Function: fromWei],
      padLeft: [Function: leftPad],
      leftPad: [Function: leftPad],
      padRight: [Function: rightPad],
      rightPad: [Function: rightPad],
      toTwosComplement: [Function: toTwosComplement]
    },
    Method: [Function: Method]
  },
  clearSubscriptions: [Function],
  options: {
    gasPrice: '3000000',
    data: undefined,
    from: undefined,
    gas: undefined,
    address: [Getter/Setter],
    jsonInterface: [Getter/Setter]
  },
  defaultAccount: [Getter/Setter],
  defaultBlock: [Getter/Setter],
  methods: {
    approve: [Function: bound _createTxObject],
    '0x095ea7b3': [Function: bound _createTxObject],
    'approve(address,uint256)': [Function: bound _createTxObject],
    transfer: [Function: bound _createTxObject],
    '0xa9059cbb': [Function: bound _createTxObject],
    'transfer(address,uint256)': [Function: bound _createTxObject],
    transferFrom: [Function: bound _createTxObject],
    '0x23b872dd': [Function: bound _createTxObject],
    'transferFrom(address,address,uint256)': [Function: bound _createTxObject],
    _increaseInterval: [Function: bound _createTxObject],
    '0x5ae4ac80': [Function: bound _createTxObject],
    '_increaseInterval()': [Function: bound _createTxObject],
    _maxIncreaseAmount: [Function: bound _createTxObject],
    '0x47fb39f9': [Function: bound _createTxObject],
    '_maxIncreaseAmount()': [Function: bound _createTxObject],
    _totalSupply: [Function: bound _createTxObject],
    '0x3eaaf86b': [Function: bound _createTxObject],
    '_totalSupply()': [Function: bound _createTxObject],
    allowance: [Function: bound _createTxObject],
    '0xdd62ed3e': [Function: bound _createTxObject],
    'allowance(address,address)': [Function: bound _createTxObject],
    allowed: [Function: bound _createTxObject],
    '0x5c658165': [Function: bound _createTxObject],
    'allowed(address,address)': [Function: bound _createTxObject],
    approvedInvestorList: [Function: bound _createTxObject],
    '0x7fc1970e': [Function: bound _createTxObject],
    'approvedInvestorList(address)': [Function: bound _createTxObject],
    balanceOf: [Function: bound _createTxObject],
    '0x70a08231': [Function: bound _createTxObject],
    'balanceOf(address)': [Function: bound _createTxObject],
    balances: [Function: bound _createTxObject],
    '0x27e235e3': [Function: bound _createTxObject],
    'balances(address)': [Function: bound _createTxObject],
    decimals: [Function: bound _createTxObject],
    '0x313ce567': [Function: bound _createTxObject],
    'decimals()': [Function: bound _createTxObject],
    deposit: [Function: bound _createTxObject],
    '0xf340fa01': [Function: bound _createTxObject],
    'deposit(address)': [Function: bound _createTxObject],
    getDeposit: [Function: bound _createTxObject],
    '0xe1254fba': [Function: bound _createTxObject],
    'getDeposit(address)': [Function: bound _createTxObject],
    isApprovedInvestor: [Function: bound _createTxObject],
    '0x9b1fe0d4': [Function: bound _createTxObject],
    'isApprovedInvestor(address)': [Function: bound _createTxObject],
    isToken: [Function: bound _createTxObject],
    '0xeefa597b': [Function: bound _createTxObject],
    'isToken()': [Function: bound _createTxObject],
    name: [Function: bound _createTxObject],
    '0x06fdde03': [Function: bound _createTxObject],
    'name()': [Function: bound _createTxObject],
    owner: [Function: bound _createTxObject],
    '0x8da5cb5b': [Function: bound _createTxObject],
    'owner()': [Function: bound _createTxObject],
    releaseTokenTime: [Function: bound _createTxObject],
    '0x364e74eb': [Function: bound _createTxObject],
    'releaseTokenTime()': [Function: bound _createTxObject],
    symbol: [Function: bound _createTxObject],
    '0x95d89b41': [Function: bound _createTxObject],
    'symbol()': [Function: bound _createTxObject],
    totalSupply: [Function: bound _createTxObject],
    '0x18160ddd': [Function: bound _createTxObject],
    'totalSupply()': [Function: bound _createTxObject],
    totalTokenSold: [Function: bound _createTxObject],
    '0xb5f7f636': [Function: bound _createTxObject],
    'totalTokenSold()': [Function: bound _createTxObject]
  },
  events: {
    Transfer: [Function: bound ],
    '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef': [Function: bound ],
    'Transfer(address,address,uint256)': [Function: bound ],
    Approval: [Function: bound ],
    '0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925': [Function: bound ],
    'Approval(address,address,uint256)': [Function: bound ],
    allEvents: [Function: bound ]
  },
  _address: '0xfed21AB2993fAa0E0B2Ab92752428D96370d4889',
  _jsonInterface: [
    {
      constant: false,
      inputs: [Array],
      name: 'approve',
      outputs: [Array],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function',
      signature: '0x095ea7b3'
    },
    {
      constant: false,
      inputs: [Array],
      name: 'transfer',
      outputs: [Array],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function',
      signature: '0xa9059cbb'
    },
    {
      constant: false,
      inputs: [Array],
      name: 'transferFrom',
      outputs: [Array],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function',
      signature: '0x23b872dd'
    },
    {
      inputs: [],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'constructor',
      constant: undefined
    },
    {
      anonymous: false,
      inputs: [Array],
      name: 'Transfer',
      type: 'event',
      constant: undefined,
      payable: undefined,
      signature: '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
    },
    {
      anonymous: false,
      inputs: [Array],
      name: 'Approval',
      type: 'event',
      constant: undefined,
      payable: undefined,
      signature: '0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925'
    },
    {
      constant: true,
      inputs: [],
      name: '_increaseInterval',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x5ae4ac80'
    },
    {
      constant: true,
      inputs: [],
      name: '_maxIncreaseAmount',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x47fb39f9'
    },
    {
      constant: true,
      inputs: [],
      name: '_totalSupply',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x3eaaf86b'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'allowance',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0xdd62ed3e'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'allowed',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x5c658165'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'approvedInvestorList',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x7fc1970e'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'balanceOf',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x70a08231'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'balances',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x27e235e3'
    },
    {
      constant: true,
      inputs: [],
      name: 'decimals',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x313ce567'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'deposit',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0xf340fa01'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'getDeposit',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0xe1254fba'
    },
    {
      constant: true,
      inputs: [Array],
      name: 'isApprovedInvestor',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x9b1fe0d4'
    },
    {
      constant: true,
      inputs: [],
      name: 'isToken',
      outputs: [Array],
      payable: false,
      stateMutability: 'pure',
      type: 'function',
      signature: '0xeefa597b'
    },
    {
      constant: true,
      inputs: [],
      name: 'name',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x06fdde03'
    },
    {
      constant: true,
      inputs: [],
      name: 'owner',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x8da5cb5b'
    },
    {
      constant: true,
      inputs: [],
      name: 'releaseTokenTime',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x364e74eb'
    },
    {
      constant: true,
      inputs: [],
      name: 'symbol',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x95d89b41'
    },
    {
      constant: true,
      inputs: [],
      name: 'totalSupply',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0x18160ddd'
    },
    {
      constant: true,
      inputs: [],
      name: 'totalTokenSold',
      outputs: [Array],
      payable: false,
      stateMutability: 'view',
      type: 'function',
      signature: '0xb5f7f636'
    }
  ]
}
[Finished in 20.5s]