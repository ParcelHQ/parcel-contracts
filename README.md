# 📦 Parcel - Contracts

## Setup

Create a `.env` file in the root directory which contains the keys `MNEMONIC` and `INFURA_KEY`

```env
INFURA_KEY='123321...'
MNEMONIC='grass water ...'
```

## Compiling

With Truffle installed globally, you can compile the contracts by running

```bash
truffle compile
```

## Deploy

To deploy to the rinkeby testnet, run

```bash
truffle deploy --reset --network rinkeby
```

## Testing
