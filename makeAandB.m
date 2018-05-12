function [A, B] = makeAandB(tau1eye, tau2eye, alpha1eye, tau1head,tau2head, alpha1head , Delta)

Ae = [0 1 0; ...
    -1/(tau1eye*tau2eye) -(tau1eye+tau2eye)/(tau1eye*tau2eye) 1/(tau1eye*tau2eye);
    0 0 -1/alpha1eye]
be = [0 0 1/alpha1eye]'

Ah = [0 1 0; ...
    -1/(tau1head*tau2head) -(tau1head+tau2head)/(tau1head*tau2head) 1/(tau1head*tau2head);
    0 0 -1/alpha1head]
bh = [0 0 1/alpha1head]'

Ac = [Ae zeros(3,3); zeros(3,3) Ah]
Bc = [be zeros(3,1); bh zeros(3,1)]

A=[expm(Ac*Delta) zeros(6,1); zeros(1,6) 1]
B=[inv(Ac)*(expm(Ac*Delta)-eye(6))*Bc; 0 0]
