
import { useState } from 'react'
import { useWriteContract } from 'wagmi'
import { parseEther, parseUnits } from 'viem'

import abiData from '../abi/TokenVesting.json'
const vestingAbi = abiData.abi


const VESTING_ADDRESS = import.meta.env.VITE_VESTING_ADDRESS
const TOKEN_ADDRESS = import.meta.env.VITE_TOKEN_ADDRESS

const erc20Abi = [
  {
    "type": "function",
    "name": "approve",
    "stateMutability": "nonpayable",
    "inputs": [
      {"name": "spender", "type": "address"},
      {"name": "amount", "type": "uint256"}
    ],
    "outputs": [{"name": "", "type": "bool"}]
  }
]

export function AdminPanel() {
  const [beneficiary, setBeneficiary] = useState('')
  const [amount, setAmount] = useState('')
  const [cliff, setCliff] = useState('0')
  const [duration, setDuration] = useState('31536000') // 1 year default

  const { writeContract, isPending, error } = useWriteContract()

  const handleApprove = () => {
    writeContract({
      address: TOKEN_ADDRESS,
      abi: erc20Abi,
      functionName: 'approve',
      args: [VESTING_ADDRESS, parseEther(amount)]
    })
  }

  const handleAddVesting = (e) => {
    e.preventDefault()
    writeContract({
      address: VESTING_ADDRESS,
      abi: vestingAbi,
      functionName: 'addBeneficiary',
      args: [
        beneficiary,
        parseUnits(amount, 18),
        BigInt(cliff),
        BigInt(duration)
      ]
    })
  }


  return (
    <div style={{ marginTop: 40, borderTop: '1px solid #ccc', paddingTop: 20 }}>
      <h3>Admin Panel: Add Vesting</h3>
      <form onSubmit={handleAddVesting} style={{ display: 'flex', flexDirection: 'column', gap: 10, maxWidth: 400 }}>
        <input
          placeholder="Beneficiary Address (0x...)"
          value={beneficiary}
          onChange={(e) => setBeneficiary(e.target.value)}
          required
        />
        <input
          placeholder="Token Amount"
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          required
        />
        <input
          placeholder="Cliff Duration (seconds)"
          type="number"
          value={cliff}
          onChange={(e) => setCliff(e.target.value)}
          required
        />
        <input
          placeholder="Vesting Duration (seconds)"
          type="number"
          value={duration}
          onChange={(e) => setDuration(e.target.value)}
          required
        />
        <button type="button" onClick={handleApprove} disabled={isPending || !amount}>
          {isPending ? 'Approving...' : 'Approve Tokens'}
        </button>
        <button type="submit" disabled={isPending}>
          {isPending ? 'Adding...' : 'Add Vesting'}
        </button>
      </form>
      {error && <p style={{ color: 'red' }}>Error: {error.message}</p>}
      <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
        1. Enter the details and click "Approve Tokens". 2. Wait for confirmation. 3. Click "Add Vesting".
      </p>
    </div>
  )
}
