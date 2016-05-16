(define (problem rob-01)
    (:domain robotCafeX)
    (:objects

        ;; Definisco le stanze
        s1  s2  s3  s4  s5  s6
        s7  s8  s9  s10 s11 s12
        s13 s14 s15 s16 s17 s18
        s19 s20 s21 s22 s23 s24

        ;; Definisco il robotCafe
        robCafe1

        ;; Definisco le persone
        man1
        man2

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
    	banc1

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
        card1
        card2

        ;; Definisco i pin
        pin1
        pin2
    )

    (:init

        ;; Dichiara la connessione tra le stanze
    	(conn s1 s2)   (conn s2 s1)
        (conn s2 s3)   (conn s3 s2)
        (conn s3 s4)   (conn s4 s3)
    	(conn s4 s5)   (conn s5 s4)
    	(conn s5 s6)   (conn s6 s5)

    	(conn s7 s8)   (conn s8 s7)
    	(conn s8 s9)   (conn s9 s8)
        (conn s9 s10)  (conn s10 s9)
        (conn s10 s11) (conn s11 s10)
        (conn s11 s12) (conn s12 s11)

        (conn s13 s14) (conn s14 s13)
        (conn s14 s15) (conn s15 s14)
        (conn s15 s16) (conn s16 s15)
        (conn s16 s17) (conn s17 s16)
        (conn s17 s18) (conn s18 s17)


        (conn s19 s20) (conn s20 s19)
        (conn s20 s21) (conn s21 s20)
        (conn s21 s22) (conn s22 s21)
        (conn s22 s23) (conn s23 s22)
        (conn s23 s24) (conn s24 s23)

        ;; Dichiara gli oggetti di tipo ascensore e la loro posizione
    	(take_asc l1 s1)  (take_asc l2 s7)
        (take_asc l3 s13) (take_asc l4 s19)

        ;; Dichiaro la connessione degli ascensori
    	(asc l1 l2) (asc l2 l1)
    	(asc l2 l3) (asc l3 l2)
        (asc l3 l4) (asc l4 l3)
        (asc l4 l1) (asc l1 l4)
        (asc l3 l1) (asc l1 l3)

        ;; Dichiaro gli oggetti di tipo scale e la loro posizione
    	(stairs st1 s6)  (stairs st2 s12)
        (stairs st3 s18) (stairs st4 s24)

        ;; Dichiaro la connessione delle scale
    	(climb s6 s12)  (climb s12 s6)
    	(climb s12 s18) (climb s18 s12)
        (climb s18 s24) (climb s24 s18)

        ;; Dichiaro gli oggetti distributori
    	(distr ds1)
        (distr ds2)

        ;; Dichiaro quale oggetto è un'entità
    	(ent robCafe1)
    	(ent man1)
    	(ent man2)

        ;; Dichiaro gli oggetti che sono umani e chi no
    	(is_human man1) (not (is_human robCafe1))
    	(is_human man2)

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
    	     (have_money man1 money1)       (have_money man1 money2)
        (not (have_money man1 money3)) (not (have_money man1 money4))
        (not (have_money man1 money5)) (not (have_money man1 money6))
        (not (have_money man1 money7)) (not (have_money man1 money8))

        (not (have_money man2 money1)) (not (have_money man2 money2))
             (have_money man2 money3)       (have_money man2 money4)
        (not (have_money man2 money5)) (not (have_money man2 money6))
        (not (have_money man2 money7)) (not (have_money man2 money8))

    	(not (have_money robCafe1 money1)) (not (have_money robCafe1 money2))
        (not (have_money robCafe1 money3)) (not (have_money robCafe1 money4))
        (not (have_money robCafe1 money5)) (not (have_money robCafe1 money6))
        (not (have_money robCafe1 money7)) (not (have_money robCafe1 money8))

        (not (have_money banc1 money1)) (not (have_money banc1 money2))
        (not (have_money banc1 money3)) (not (have_money banc1 money4))
             (have_money banc1 money5)       (have_money banc1 money6)
             (have_money banc1 money7)       (have_money banc1 money8)

        ;; Dichiaro l'associazione distributore -> drink
        (have_drink ds1 coffee1)    (have_drink ds2 coffee2)
        (have_drink ds1 chocolate1) (have_drink ds2 the1)
                                    (have_drink ds2 the2)

        ;; Dichiaro dove si trova il bancomat
    	(bancomat banc1 s2)

        ;; Dichiaro la posizione degli oggetti
        (at robCafe1 s9)

        (at man1 s5)
    	(at man2 s15)

        (at ds1 s3)
        (at ds2 s9)

        ;; Dichiaro gli oggetti carte
        (card card1)
        (card card2)

        ;; Dichiaro gli oggetti pin
        (pin pin1)
        (pin pin2)

        ;; Dichiaro la connessione carta/pin
        (card_pin card1 pin1)
        (card_pin card2 pin2)

        ;; Dichiaro la possessione delle carte
        (have_card man1 card1)
        (have_card man2 card2)

        ;; Dichiaro la possessione dei pin
        (have_pin man1 pin1)
        (have_pin man2 pin2)
    )

    (:goal
        (and
            (take_drink man1 chocolate1)
            (take_drink man1 coffee1)
            (take_drink man1 coffee2)
            (take_drink man2 the1)
            (take_drink man2 the2)
        )
    )
)
