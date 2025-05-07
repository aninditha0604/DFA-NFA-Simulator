#lang scheme
(require (lib "tls.ss" "OWU") )
(require (lib "trace.ss"))

;testing example
(define test-transitions 
  '((q0 a q1) (q0 b q2) (q0 epsilon q3) 
    (q1 a q1) (q1 b q2)
    (q2 a q2) (q2 b q1)
    (q3 a q4) (q3 epsilon q2)
    (q4 b q0)))

(define test-states '(q0 q1 q2 q3 q4))
(define test-accepting-states '(q2 q4))

;same accepting function from dfa that I'm just using as a helper 
(define is-accepting-state? 
  (lambda (states current-state) 
    (if (null? states) 
        #f 
        (if (equal? (car states) current-state) 
            #t 
            (is-accepting-state? (cdr states) current-state)))))

;; Check if any state in a list is accepting
(define is-accepting-states? 
  (lambda (states current-states)
    (if (null? current-states)
        #f
        (or (is-accepting-state? states (car current-states))
            (is-accepting-states? states (cdr current-states))))))

(is-accepting-states? test-accepting-states '(q0 q1 q2))
(is-accepting-states? test-accepting-states '(q0 q1 q3))

; check if an element is in the list
(define in-list?
  (lambda (x lst)
    (if (null? lst)
        #f
        (if (equal? x (car lst))
            #t
            (in-list? x (cdr lst))))))

; combine two lists without repetition
(define combine
  (lambda (lst1 lst2)
    (if (null? lst1)
        lst2
        (if (in-list? (car lst1) lst2)
            (combine (cdr lst1) lst2)
            (combine (cdr lst1) (cons (car lst1) lst2))))))

;same get next states as dfa
(define get-next-states 
  (lambda (transitions current-state x)
    (if (null? transitions)
        '() 
        (if (and (equal? (caar transitions) current-state) 
                 (equal? (cadar transitions) x))
            (cons (caddar transitions) 
                  (get-next-states (cdr transitions) current-state x))
            (get-next-states (cdr transitions) current-state x)))))

(get-next-states test-transitions 'q0 'epsilon)

(define process-next-states
  (lambda (transitions states input)
    (if (null? states)
        '()
        (combine
         (get-next-states transitions (car states) input)
         (process-next-states transitions (cdr states) input)))))

(process-next-states test-transitions '(q0 q1 q2) 'b)

; get all the states you can go to from a single state via epsilon transitions
(define get-epsilon-closure
  (lambda (transitions state visited)
    (if (in-list? state visited)
        visited
        (let* ((new-visited (cons state visited))
               (epsilon-states (get-next-states transitions state 'epsilon)))
          (if (null? epsilon-states)
              new-visited
              (get-epsilon-closure-helper transitions epsilon-states new-visited))))))

(define get-epsilon-closure-helper
  (lambda (transitions states visited)
    (if (null? states)
        visited
        (get-epsilon-closure-helper transitions (cdr states) (get-epsilon-closure transitions (car states) visited)))))

(get-epsilon-closure test-transitions 'q0 '())
(get-epsilon-closure-helper test-transitions '(q1 q4) '())

;process both normal and epsilon transitions of an input string until the end
(define nfa-helper
  (lambda (transitions states str)
    (define states-with-epsilon 
      (get-epsilon-closure-helper transitions states '()))
    (if (null? str)
        states-with-epsilon
        (let ((next-states (process-next-states transitions states-with-epsilon (car str))))
          (nfa-helper transitions next-states (cdr str))))))

(nfa-helper test-transitions '(q0) '(a b))

(define nfa-simulator
  (lambda (input-list)
    (define states (car input-list))
    (define transitions (cadr input-list))
    (define initial-state (caddr input-list))
    (define accepting-states (cadddr input-list))
    (define input-string (car (cddddr input-list)))
    (define final-states (nfa-helper transitions (list initial-state) input-string))
    (is-accepting-states? accepting-states final-states)))

(define graphviz-to-file
  (lambda (input-list filename)
    (define states (car input-list))
    (define transitions (cadr input-list))
    (define initial-state (caddr input-list))
    (define accepting-states (cadddr input-list))
    
    ;; Open file for output
    (define out-port (open-output-file filename #:exists 'replace))
    
    ;; Write to the file instead of displaying
    (fprintf out-port "digraph NFA {\n")
    (fprintf out-port "  rankdir=LR;\n")
    (fprintf out-port "  node [shape = circle];\n\n")
    
    (fprintf out-port "  \"\" [shape=none];\n")
    (fprintf out-port "  \"\" -> \"~a\";\n\n" initial-state)
    
    (cond 
      ((not (null? accepting-states))
       (fprintf out-port "  node [shape = doublecircle]; ")
       (for-each  ; using for-each instead of map to ensure side effects
        (lambda (state) 
          (fprintf out-port "\"~a\" " state))
        accepting-states)
       (fprintf out-port ";\n")
       (fprintf out-port "  node [shape = circle];\n\n")))
    
    (for-each  ; using for-each instead of map to ensure side effects
     (lambda (transition)
       (let ((from-state (car transition))
             (input (cadr transition))
             (to-state (caddr transition)))
         (fprintf out-port "  \"~a\" -> \"~a\" [label=\"~a\"];\n"
                 from-state
                 to-state
                 (if (eq? input 'epsilon)
                     "ε"  ; keeping your original epsilon representation
                     input))))
     transitions)
    
    (fprintf out-port "}\n")
    
    ;; Close the file
    (close-output-port out-port)
    
    ;; Print confirmation message
    (display "DOT file created at: ")
    (display filename)
    (newline)
    
    ;; Return the filename
    filename))


(define nfa
  '((q0 q1 q2)  ; states
    ((q0 a q0) (q0 a q1) (q0 epsilon q2) (q1 b q2))  ; transitions 
    q0  ; initial state
    (q2)  ; accepting states
    (a a a)))  ; input string


(nfa-simulator nfa)
(graphviz-to-file nfa "nfa.dot")
