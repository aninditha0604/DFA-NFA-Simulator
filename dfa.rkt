#lang scheme
(require (lib "tls.ss" "OWU") )
(require (lib "trace.ss"))

; get what stats we transition into based on a list and our current state and input alphabet
(define get-next-state
  (lambda (transitions current-state x)
    (if (null? transitions)
        #f ; is false okay or should i do something else? DO EMPTY STRING 
        (if (and (equal? (caar transitions) current-state)
                 (equal? (cadar transitions) x))
            (caddar transitions)
            (get-next-state (cdr transitions) current-state x)))))

(get-next-state '((q1 a q2) (q1 b q1) (q2 a q3) (q3 b q3)) 'q1 'b)
(get-next-state '((q1 a q2) (q1 b q1) (q2 a q3) (q3 b q3)) 'q2 'a) 
(get-next-state '((q1 a q2) (q1 b q1) (q2 a q3) (q3 b q3)) 'q3 'a)

; process our input string until the end
(define dfa-helper
 (lambda (transitions current-state str)
   (if (null? str)
       current-state
       (dfa-helper transitions (get-next-state transitions current-state (car str)) (cdr str)))))

(dfa-helper '((q1 a q2) (q1 b q1) (q2 a q3) (q3 b q3)) 'q1 '(b b b a a b)) ; what do I do when the transition doesn't exist?
; check if my current state is an accepting state or not 
(define is-accepting-state?
  (lambda(states current-state)
    (if (null? states)
        #f
        (if (equal? (car states) current-state)
            #t
            (is-accepting-state? (cdr states)  current-state)))))

(is-accepting-state? '(q1 q2 q3) 'q2)
(is-accepting-state? '(q1 q2 q3) 'q4)
(is-accepting-state? '(q1 q2 q3) 'q3)
;
(define dfa-simulator 
  (lambda (input-list)
    (define states (car input-list))
    (define transitions (cadr input-list))
    (define initial-state (caddr input-list))
    (define accepting-state (cadddr input-list))
    (define input-string (car (cddddr input-list)))
    (is-accepting-state? accepting-state (dfa-helper transitions initial-state input-string))))

(define graphviz-to-file
  (lambda (input-list filename)
    (define states (car input-list))
    (define transitions (cadr input-list))
    (define initial-state (caddr input-list))
    (define accepting-states (cadddr input-list))

    (define out-port (open-output-file filename #:exists 'replace))

    (fprintf out-port "digraph DFA {\n")
    (fprintf out-port "  rankdir=LR;\n")
    (fprintf out-port "  node [shape = circle];\n\n")

    (fprintf out-port "  \"\" [shape=none];\n")
    (fprintf out-port "  \"\" -> \"~a\";\n\n" initial-state)

    (cond 
      ((not (null? accepting-states))
       (fprintf out-port "  node [shape = doublecircle]; ")
       (for-each
        (lambda (state) 
          (fprintf out-port "\"~a\" " state))
        accepting-states)
       (fprintf out-port ";\n")
       (fprintf out-port "  node [shape = circle];\n\n")))

    (for-each
     (lambda (transition)
       (let ((from-state (car transition))
             (input (cadr transition))
             (to-state (caddr transition)))
         (fprintf out-port "  \"~a\" -> \"~a\" [label=\"~a\"];\n"
                 from-state
                 to-state
                 input)))
     transitions)

    (fprintf out-port "}\n")
    (close-output-port out-port)
    (display "DFA DOT file created at: ")
    (display filename)
    (newline)
    filename))


(define dfa
  '((q0 q1)                                     ; states
    ((q0 a q1) (q0 b q0) (q1 a q1) (q1 b q0))  ; transitions
    q0                                          ; initial state
    (q1)                                        ; accepting states
    (a b a)))                                   ; input string


(dfa-simulator  dfa)
(graphviz-to-file dfa "dfa.dot")
