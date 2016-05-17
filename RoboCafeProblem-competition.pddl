(define (problem rob-01)
    (:domain robotCafeX)
    (:objects


        ; TEAM : AgentRobotX
		; MEMBER:
        ;     Alessandro Bigiotti Matr. 281812
		;     Valerio Belli Matr. 283514

        ;; Definisco le stanze
        a3 b3 c3
        a2 b2 c2
        a1 b1 c1

        ;; Definisco il robotCafe
        r1

        ;; Definisco le persone
        u1
        u2

        ;; Definisco gli ascensori
        l1
        l2
        l3

        ;; Definisco le scale
        st1
        st2
        st3

        ;; Definisco i distributori
        ds1

        ;;definisco le bevande
        chocolate1 chocolate2
        coffee1 coffee2

        ;; Definisco i bancomat
    	bancomat

        ;; Definisco i soldi
        money1
        money2
        money3
        money4
        ;; Definisco le carte
        mastercard
        visa

        ;; Definisco i pin
        pin_mastercard
        pin_visa
    )

    (:init

        ;; Dichiara la connessione tra le stanze
    	(conn a3 b3)   (conn b3 a3)
        (conn b3 c3)   (conn c3 b3)

    	(conn a2 b2)   (conn b2 a2)
    	(conn b2 c2)   (conn c2 b2)

        (conn a1 b1) (conn b1 a1)
        (conn b1 c1) (conn c1 b1)


        ;; Dichiara che una locazione è una stanza
        (room a3) (room b3) (room c3)
        (room a2) (room b2) (room c2)
        (room a1) (room b1) (room c1)

        ;; Dichiara gli oggetti di tipo ascensore e la loro posizione
    	(take_asc l1 a1)  (take_asc l2 a2)
        (take_asc l3 a3)

        ;; Dichiaro la connessione degli ascensori
    	(asc l1 l2) (asc l2 l1)
    	(asc l2 l3) (asc l3 l2)
        (asc l1 l3) (asc l3 l1)

        ;; Dichiaro gli oggetti di tipo scale e la loro posizione
    	(stairs st1 c1)  (stairs st2 c2)
        (stairs st3 c3)

        ;; Dichiaro la connessione delle scale
    	(climb c1 c2)  (climb c2 c1)
    	(climb c2 c3) (climb c3 c2)

        ;; Dichiaro gli oggetti distributori
    	(distributor ds1)

        ;; Dichiaro quale oggetto è un'entità, un uomo e un robot
        (ent u1)
        (ent u2)
        (ent r1)

        (man u1)
        (man u2)

    	(robot r1)

        ;; Dichiaro i soldi
    	(money money1)
    	(money money2)
    	(money money3)
        (money money4)

        ;; Dichiaro i drink
    	(drink chocolate1) (drink coffee1) (drink chocolate2)
        (drink coffee2)

        ;; Dichiari chi ha i soldi (e quali soldi)
        (have_money u1 money1) (not (have_money u1 money2))
        (not (have_money u1 money3)) (not (have_money u1 money4))

        (not (have_money u2 money1))  (have_money u2 money2)
        (not (have_money u2 money3)) (not (have_money u2 money4))

        (not (have_money r1 money1)) (not (have_money r1 money2))
        (have_money r1 money3) (have_money r1 money4)

        ;; Dichiaro l'associazione distributore -> drink
        (have_drink ds1 coffee1)    (have_drink ds1 coffee2)
        (have_drink ds1 chocolate1) (have_drink ds1 chocolate2)

        ;; Dichiaro la posizione degli oggetti
        (at r1 a1)

        (at u1 c1)
    	(at u2 a3)

        (at ds1 b1)

        ;; Dichiaro gli oggetti carte
        (card mastercard)
        (card visa)

        ;; Dichiaro gli oggetti pin
        (pin pin_mastercard)
        (pin pin_visa)

        ;; Dichiaro la connessione carta/pin
        (card_pin mastercard pin_mastercard)
        (card_pin visa pin_visa)

        ;; Dichiaro la possessione delle carte
        (have_card u1 mastercard)
        (have_card u2 visa)

        ;; Dichiaro la possessione dei pin
        (have_pin u1 pin_mastercard)
        (have_pin u2 pin_visa)

        (not (can_order u1)) (not (can_order u2))
        (not (can_order r1))

        (available r1)

    )

    (:goal
        (and
            (take_drink u1 coffee1)
            (take_drink u2 chocolate1)
        )
    )
)
