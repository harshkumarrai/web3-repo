
import { useState } from 'react'
import { useWriteContract } from 'wagmi'
import { crowdfundingABI } from '../abi'

const CONTRACT = "0x53da9C3444085D4b3c50Fc38A0a96Cf18413C2D5"

export default function Withdraw() {
  const [isLoading, setIsLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [campaignId, setCampaignId] = useState('')
  
  const { writeContract } = useWriteContract()

  async function withdraw() {
    if (!campaignId) {
      setMessage('Please enter a campaign ID')
      return
    }
    
    if (parseInt(campaignId) < 0) {
      setMessage('Campaign ID must be a positive number')
      return
    }

    setIsLoading(true)
    setMessage('')

    try {
      writeContract({
        address: CONTRACT,
        abi: crowdfundingABI,
        functionName: "withdraw",
        args: [Number(campaignId)],
      })
      setMessage('Withdrawal submitted! Check MetaMask for confirmation.')
      setCampaignId('')
    } catch (error) {
      setMessage(`Error: ${error.message}`)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div style={{ 
      padding: '20px', 
      border: '1px solid #ddd', 
      borderRadius: '8px', 
      margin: '10px 0' 
    }}>
      <h3>Withdraw</h3>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        <input 
          placeholder="Campaign ID" 
          value={campaignId}
          onChange={(e) => setCampaignId(e.target.value)}
          disabled={isLoading}
        />
        <button 
          onClick={withdraw} 
          disabled={isLoading}
          style={{ 
            padding: '10px',
            backgroundColor: isLoading ? '#ccc' : '#dc3545',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          {isLoading ? 'Withdrawing...' : 'Withdraw'}
        </button>
      </div>
      {message && (
        <div style={{ 
          marginTop: '10px', 
          padding: '10px',
          backgroundColor: message.includes('Error') ? '#f8d7da' : '#d4edda',
          color: message.includes('Error') ? '#721c24' : '#155724',
          border: `1px solid ${message.includes('Error') ? '#f5c6cb' : '#c3e6cb'}`,
          borderRadius: '4px'
        }}>
          {message}
        </div>
      )}
    </div>
  )
}
