
import { useState } from 'react'
import { useWriteContract } from 'wagmi'
import { crowdfundingABI } from '../abi'
import { parseEther } from 'viem'

const CONTRACT = "0x53da9C3444085D4b3c50Fc38A0a96Cf18413C2D5"

export default function CreateCampaign() {
  const [isLoading, setIsLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [formData, setFormData] = useState({ goal: '', duration: '' })
  
  const { writeContract } = useWriteContract()

  async function create() {
    const { goal, duration } = formData
    
    // Validation
    if (!goal || !duration) {
      setMessage('Please fill in both fields')
      return
    }
    
    if (parseFloat(goal) <= 0) {
      setMessage('Goal must be greater than 0')
      return
    }

    setIsLoading(true)
    setMessage('')

    try {
      writeContract({
        address: CONTRACT,
        abi: crowdfundingABI,
        functionName: "createCampaign",
        args: [parseEther(goal), Number(duration)],
      })
      setMessage('Campaign creation submitted! Check MetaMask for confirmation.')
      setFormData({ goal: '', duration: '' })
    } catch (error) {
      setMessage(`Error: ${error.message}`)
    } finally {
      setIsLoading(false)
    }
  }

  const handleInputChange = (e) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }))
  }

  return (
    <div style={{ 
      padding: '20px', 
      border: '1px solid #ddd', 
      borderRadius: '8px', 
      margin: '10px 0' 
    }}>
      <h3>Create Campaign</h3>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        <input 
          name="goal"
          placeholder="Goal (ETH)" 
          value={formData.goal}
          onChange={handleInputChange}
          disabled={isLoading}
        />
        <input 
          name="duration"
          placeholder="Duration (seconds)" 
          value={formData.duration}
          onChange={handleInputChange}
          disabled={isLoading}
        />
        <button 
          onClick={create} 
          disabled={isLoading}
          style={{ 
            padding: '10px',
            backgroundColor: isLoading ? '#ccc' : '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          {isLoading ? 'Creating...' : 'Create Campaign'}
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
