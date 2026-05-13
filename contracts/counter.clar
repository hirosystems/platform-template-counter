;; An on-chain counter that stores a count for each caller

(define-constant ERR_COUNTER_OVERFLOW (err u100))
(define-constant MAX_UINT u340282366920938463463374607431768211455)

(define-map counters
  principal
  uint
)

(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

(define-public (count-up)
  (let
    (
      (caller contract-caller)
      (current-count (get-count caller))
    )
    (asserts! (< current-count MAX_UINT) ERR_COUNTER_OVERFLOW)
    (let
      (
        (new-count (+ current-count u1))
      )
      (map-set counters caller new-count)
      (ok new-count)
    )
  )
)