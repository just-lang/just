(define prec-assignment '(<- =))
(define prec-conditional '(?))
(define prec-pair '(=>))
(define prec-negation '(not) '(!))
(define prec-comparison '(equal) '(== != < > <= >=))
(define prec-lazy-or '(|))
(define prec-lazy-and '(&))
(define prec-identity '(is) '(=== !==))
(define prec-plus '(+ -))
(define prec-times '(* /))
(define prec-power '(^))

(define prec-names '(prec-assignment prec-conditional prec-pair
                     prec-negation prec-comparison prec-lazy-or
                     prec-lazy-and prec-identity prec-plus
                     prec-times prec-power))

(define (lexer input)
  (define tokens '()) ; List to store the tokens
  
  ; Helper function to add a token to the token list
  (define (add-token type value)
    (set! tokens (append tokens (list (cons type value)))))
  
  ; Tokenize the input
  (let loop ((input input))
    (cond
      ; Base case: when input is empty
      ((null? input) tokens)
      
      ; Skip whitespace characters
      ((char-whitespace? (car input))
       (loop (cdr input)))
      
      ; Handle symbols
      ((char-alphabetic? (car input))
       (let ((symbol (list->string (take-while char-alphanumeric? input))))
         (add-token 'symbol symbol)
         (loop (drop-while char-alphanumeric? input))))
      
      ; Handle numbers
      ((char-numeric? (car input))
       (let ((number (list->string (take-while char-numeric? input))))
         (add-token 'number (string->number number))
         (loop (drop-while char-numeric? input))))
      
      ; Handle strings
      ((char=? (car input) #\")
       (let ((string (list->string (take-while (lambda (c) (not (char=? c #\")))) (cdr input))))
         (add-token 'string string)
         (loop (drop (+ 2 (string-length string)) input))))
      
      ; Handle operators
      ((char=? (car input) #\+)
       (add-token 'operator '+)
       (loop (cdr input)))
      ((char=? (car input) #\-)
       (add-token 'operator '-)
       (loop (cdr input)))
      ((char=? (car input) #\*)
       (add-token 'operator '*)
       (loop (cdr input)))
      ((char=? (car input) #\/)
       (add-token 'operator '/)
       (loop (cdr input)))
      ((char=? (car input) #\^)
       (add-token 'operator '^)
       (loop (cdr input)))
      
      ; Handle other characters as unknown
      (else
       (add-token 'unknown (car input))
       (loop (cdr input))))))

; Test the lexer
(lexer '(int num <- 5)) ; Example input
