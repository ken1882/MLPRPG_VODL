
module TacticCommandModule
  
  Basic = [
    # category    #condition        # args    # action          # args
    [:targeting, :nearest_visible,  nil,      :set_target,      nil],
    [:fighting,  :any,              nil,      :attack_mainhoof, nil],
  ]
  
end
