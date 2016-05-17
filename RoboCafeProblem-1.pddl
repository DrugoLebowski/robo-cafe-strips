(define (problem rob-01)
    (:domain robotCafeX)
    (:objects


        ; TEAM : AgentRobotX
		; MEMBER:
        ;     Alessandro Bigiotti Matr. 281812
		;     Valerio Belli Matr. 283514

        ;; Definisco le stanze
        s1  s2  s5  s6
        s7  s8  s11 s12
        s13 s14 s17 s18
        s19 s20 s23 s24

        ;; Definisco il robotCafe
        robot_x

        ;; Definisco le persone
        francesco
        roberto

        ;; Definisco gli ascensori
        l1
        l2
        l3
        l4

        ;; Definisco le scale
        st1
        st2
        st3
        st4

        ;; Definisco i distributori
        ds1
        ds2

        ;;definisco le bevande
        the1 coffee1 chocolate1
        the2 coffee2

        ;; Definisco i bancomat
    	bancomat

        ;; Definisco i soldi
        money1
        money2
        money3
        money4
        money5
        money6
        money7
        money8

        ;; Definisco le carte
        mastercard
        visa

        ;; Definisco i pin
        pin_mastercard
        pin_visa
    )

    (:init

        ;; Dichiara la connessione tra le stanze
    	(conn s1 s2)   (conn s2 s1)
        (conn s2 s5)   (conn s5 s2)
    	(conn s5 s6)   (conn s6 s5)

    	(conn s7 s8)   (conn s8 s7)
        (conn s8 s11)  (conn s11 s8)
        (conn s11 s12) (conn s12 s11)

        (conn s13 s14) (conn s14 s13)
        (conn s14 s18) (conn s18 s14)
        (conn s17 s18) (conn s18 s17)


        (conn s19 s20) (conn s20 s19)
        (conn s20 s23) (conn s23 s20)
        (conn s23 s24) (conn s24 s23)

        ;; Dichiara che una locazione è una stanza
        (room s1) (room s2) (room s5) (room s6)
        (room s7) (room s8) (room s11) (room s12)
        (room s13) (room s14) (room s17) (room s18)
        (room s19) (room s20) (room s23) (room s24)

        ;; Dichiara gli oggetti di tipo ascensore e la loro posizione
    	(take_asc l1 s1)  (take_asc l2 s7)
        (take_asc l3 s13) (take_asc l4 s19)

        ;; Dichiaro la connessione degli ascensori
    	(asc l1 l2) (asc l2 l1)
    	(asc l2 l3) (asc l3 l2)
        (asc l3 l4) (asc l4 l3)
        (asc l4 l1) (asc l1 l4)
        (asc l3 l1) (asc l1 l3)
        (asc l4 l2) (asc l2 l4)

        ;; Dichiaro gli oggetti di tipo scale e la loro posizione
    	(stairs st1 s6)  (stairs st2 s12)
        (stairs st3 s18) (stairs st4 s24)

        ;; Dichiaro la connessione delle scale
    	(climb s6 s12)  (climb s12 s6)
    	(climb s12 s18) (climb s18 s12)
        (climb s18 s24) (climb s24 s18)

        ;; Dichiaro gli oggetti distributori
    	(distributor ds1)
        (distributor ds2)

        ;; Dichiaro quale oggetto è un'entità, un uomo e un robot
        (ent francesco)
        (ent roberto)
        (ent robot_x)

        (man francesco)
        (man roberto)

    	(robot robot_x)

        ;; Dichiaro i soldi
    	(money money1)
    	(money money2)
    	(money money3)
        (money money4)
        (money money5)
        (money money6)
        (money money7)
        (money money8)

        ;; Dichiaro i drink
    	(drink the1) (drink coffee1) (drink chocolate1)
        (drink the2) (drink coffee2)

        ;; Dichiari chi ha i soldi (e quali soldi)
        (not (have_money francesco money1)) (not (have_money francesco money2))
        (not (have_money francesco money3)) (not (have_money francesco money4))
        (not (have_money francesco money5)) (not (have_money francesco money6))
        (not (have_money francesco money7)) (not (have_money francesco money8))

        (not (have_money roberto money1)) (not (have_money roberto money2))
        (not (have_money roberto money3)) (not (have_money roberto money4))
        (not (have_money roberto money5)) (not (have_money roberto money6))
        (not (have_money roberto money7)) (not (have_money roberto money8))

        (have_money robot_x money1) (not (have_money robot_x money2))
        (not (have_money robot_x money3)) (not (have_money robot_x money4))
        (not (have_money robot_x money5)) (not (have_money robot_x money6))
        (not (have_money robot_x money7)) (not (have_money robot_x money8))

        (not (have_money bancomat money1)) (not (have_money bancomat money2))
        (not (have_money bancomat money3)) (not (have_money bancomat money4))
             (have_money bancomat money5)       (have_money bancomat money6)
             (have_money bancomat money7)       (have_money bancomat money8)

        ;; Dichiaro l'associazione distributore -> drink
        (have_drink ds1 coffee1)    (have_drink ds2 coffee2)
        (have_drink ds1 chocolate1) (have_drink ds2 the1)
                                    (have_drink ds2 the2)

        ;; Dichiaro dove si trova il bancomat
    	(bancomat bancomat s2)

        ;; Dichiaro la posizione degli oggetti
        (at robot_x s20)

        (at francesco s1)
    	(at roberto s19)

        (at ds1 s6)
        (at ds2 s23)

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
        (have_card francesco mastercard)
        (have_card roberto visa)

        ;; Dichiaro la possessione dei pin
        (have_pin francesco pin_mastercard)
        (have_pin roberto pin_visa)

        (not (can_order francesco)) (not (can_order roberto))
        (not (can_order robot_x))

        (available robot_x)
    )

    (:goal
        (and
            (take_drink francesco the2)
            (take_drink roberto chocolate1)
        )
    )
)
