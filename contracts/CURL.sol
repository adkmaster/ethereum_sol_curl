
pragma solidity ^0.4.26;


contract CURL {

    uint constant HASH_LENGTH = 243;
    uint constant STATE_LENGTH = 3 * HASH_LENGTH;
    uint constant NUMBER_OF_ROUNDS = 27;
    
     
   
    constructor()public{
    }
    
    // note: TRUTH_TABLE not imple,mented as array as this would only be possible as "view" but we want "pure"
    
    function TRUTH_TABLE(uint idx) public pure returns (int) { 
        int[9] memory truth = [ int(1), int(0), int(-1), int(1), int(-1), int(0), int(-1), int(1), int(0) ];
        return int(truth[idx]);
    }
    
    function absorb(int[] trits, int[] state) public pure returns (int[]) {
       assert(trits.length % 243 == 0);
       for (uint i = 0; i < trits.length; i+=243) {
            for (uint j = 0; j < 243; j++){
                state[j] = trits[i+j];
            }
            state = transform(state);
       }
       
       return trits;
    }
    
     function transform(int[] state) public pure returns (int[]) {
       int[STATE_LENGTH] memory scratchpad; 
       int scratchpadIndex = 0;
        for (uint round = 0; round < NUMBER_OF_ROUNDS; round++) {
           for (uint i = 0; i < STATE_LENGTH; i++) 
                scratchpad[i] = state[i];
           
           for (uint stateIndex = 0; stateIndex < STATE_LENGTH; stateIndex++) {
                state[stateIndex] = TRUTH_TABLE(
                                        uint(
                                           scratchpad[uint(scratchpadIndex)] + 
                                           scratchpad[uint(scratchpadIndex += (int(scratchpadIndex) < int(365) ? int(364) : int(-365)))] * 3 + 4
                                           )
                                         );
            }
        }
        return state;
    }
    
     function squeeze(int[] state) public pure returns (int[243]) {
       int[243] memory scratchpad; 
       for (uint i = 0; i < 243; i++) {
           scratchpad[i] = state[i];
       }
       transform(state);  // potentially not needed
       return scratchpad;
    }

}