import { useAccount, useReadContract, useWriteContract } from 'wagmi'









import abiData from '../abi/TokenVesting.json'
const vestingAbi = abiData.abi

import { formatEther } from 'viem'

const VESTING_ADDRESS = import.meta.env.VITE_VESTING_ADDRESS

export function VestingDashboard() {
  const { address, isConnected } = useAccount()

  const { data: vesting, isLoading, error } = useReadContract({
    address: VESTING_ADDRESS,
    abi: vestingAbi,
    functionName: 'vestings',
    args: [address],
    query: {
        enabled: !!address,
    },
    watch: true
  })

  const { data: vested } = useReadContract({
    address: VESTING_ADDRESS,
    abi: vestingAbi,
    functionName: 'vestedAmount',
    args: [address],
    query: {
        enabled: !!address,
    },
    watch: true
  })

  const { writeContract } = useWriteContract()

  if (!isConnected) return <p>Please connect your wallet to view vesting.</p>
  if (isLoading) return <p>Loading vesting data...</p>
  if (error) return (
    <div>
        <p>Error fetching vesting: {error.message}</p>
        <p>Contract Address: {VESTING_ADDRESS}</p>
    </div>
  )
  if (!vesting) return <p>No vesting data returned.</p>

  const total = vesting.totaltokens || vesting.total || vesting[0]
  const released = vesting.releasestokens || vesting.released || vesting[1]

  if (!total || total === 0n) return <p>No vesting schedule found for {address}</p>

  const claimable = vested ? (vested - (released || 0n)) : 0n

  return (
    <div style={{ marginTop: 20 }}>
      <h2>Vesting Dashboard</h2>

      <p>Total Allocated: {total ? formatEther(total) : '0'} tokens</p>
      <p>Vested: {vested ? formatEther(vested) : '0'} tokens</p>
      <p>Claimed: {released ? formatEther(released) : '0'} tokens</p>
      <p>Claimable: {claimable ? formatEther(claimable) : '0'} tokens</p>

      <button
        disabled={!claimable || claimable <= 0n}
        onClick={() =>
          writeContract({
            address: VESTING_ADDRESS,
            abi: vestingAbi,
            functionName: 'release'
          })
        }
      >
        Claim Tokens
      </button>
    </div>
  )
}
