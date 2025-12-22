import { createConfig, http } from 'wagmi'
import { hardhat } from 'wagmi/chains'

export const config = createConfig({
  connectors: [
    injected(),
  ],
  chains: [hardhat],
  transports: {
    [hardhat.id]: http()
  }
})
