# Crowdfunding dApp - Add Campaign ID Query Features

## Task Summary
Add functionality for:
1. Contributors to check which campaign IDs they funded
2. Campaign organizers to get the IDs of campaigns they created

## Implementation Plan

### Phase 1: Smart Contract Updates
- [ ] 1. Add tracking mappings for user campaign relationships
- [ ] 2. Add function `getCampaignsByCreator(address _creator)` 
- [ ] 3. Add function `getCampaignsByContributor(address _contributor)`
- [ ] 4. Update `createCampaign` to track creator
- [ ] 5. Update `contribute` to track contributor
- [ ] 6. Update ABI in frontend

### Phase 2: Frontend Components
- [ ] 7. Create new component `MyCampaigns.jsx` for organizers
- [ ] 8. Create new component `MyContributions.jsx` for contributors  
- [ ] 9. Add both components to main App.jsx
- [ ] 10. Add proper styling and loading states

### Phase 3: Testing
- [ ] 11. Test smart contract functions
- [ ] 12. Test frontend components
- [ ] 13. Verify all functionality works correctly

## Technical Details
- **Display**: Just campaign IDs as requested
- **Smart Contract**: Add user tracking mappings
- **Frontend**: New React components with useReadContract hooks
- **Styling**: Consistent with existing design
