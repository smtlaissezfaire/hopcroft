module Hopcroft
  module Machine
    extend Using
    
    using :NfaTransitionTable
    using :State
    using :Transition
    using :StateMachine
    using :EpsilonTransition
    using :AnyCharTransition
    using :TableConverter
    using :TableDisplayer
  end
end
