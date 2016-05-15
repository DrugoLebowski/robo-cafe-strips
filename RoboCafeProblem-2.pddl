(define (problem rob-01)
    (:domain robotCafeX)
    (:objects

        ;;definisco le stanze
        s1  s2  s3  s4  s5  s6
        s7  s8  s9  s10 s11 s12
        s13 s14 s15 s16 s17 s18
        s19 s20 s21 s22 s23 s24

        ;;definisco il robotCafe
        robCafe1 robCafe2

        ;;definsico le persone
        man1    man2    man3

        ;;definisco gli ascensori
        l1 l2 l3 l4

        ;;definisco le scale
        st1 st2 st3 st4

        ;;definisco i distributori
        ds1 ds2 ds3 ds4 ds5 ds6

        ;;definisco le bevande
        the1 the2 the3 the4 the5
        coffee1 coffee2 coffee3 coffee4
        chocolate1 chocolate2

        ;;definisco i soldi
        money1 money2 money3 money4 money5

        ;;definisco i bancomat
    	banc1    banc2
    )

    (:init
        ;;connessione di stanze sullo stesso piano
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

        ;;definisco le stanze connesse agli ascensori

    	(take_asc l1 s1)  (take_asc l2 s7)
        (take_asc l3 s13) (take_asc l4 s19)

        ;;collego gli ascensori tra loro
    	(asc l1 l2) (asc l2 l1)
    	(asc l2 l3) (asc l3 l2)
        (asc l3 l4) (asc l4 l3)

        ;;definisco le scale connesse alle stanze
    	(stairs st1 s6)  (stairs st2 s12)
        (stairs st3 s18) (stairs st4 s24)

        ;;definisco le connessione di due piano tramite le scale
    	(climb s6 s12)  (climb s12 s6)
    	(climb s12 s18) (climb s18 s12)
        (climb s18 s24) (climb s24 s18)

        ;;definisco i distributori nelle stanze
    	(distr ds1)   (distr ds2)    (distr ds3)

        ;;specifico che robotCafe, man1, ... sono enti
    	(ent robCafe1)
        (ent robCafe2)
    	(ent man1)
    	(ent man2)
    	(ent man3)

        ;;predicato che differenzia robot da man
    	(is_human man1)
    	(is_human man2)
    	(is_human man3)
    	(not (is_human robCafe1))
        (not (is_human robCafe2))

        ;;specifico i soldi
    	(money money1)
    	(money money2)
    	(money money3)
        (money money4)
        (money money5)

        ;;dichiaro i drink
    	(drink the1) (drink the2) (drink the3) (drink the4) (drink the5)
        (drink coffee1) (drink coffee2) (drink coffee3) (drink coffee4)
        (drink chocolate1) (drink chocolate2)

        ;;predicato per assegnare soldi agli individui
    	(have_money man1 money1) (have_money man1 money2)
        (have_money man1 money3) (not (have_money man1 money4))
        (not (have_money man1 money5))

        (not (have_money man2 money1)) (not (have_money man2 money2))
        (not (have_money man2 money3)) (not (have_money man2 money4))
        (not (have_money man2 money5))

        (not (have_money man3 money1)) (not (have_money man3 money2))
        (not (have_money man3 money3)) (not (have_money man3 money4))
        (have_money man3 money5)

    	(not (have_money robCafe1 money1)) (not (have_money robCafe1 money2))
        (not (have_money robCafe1 money3)) (not (have_money robCafe1 money4))
        (not (have_money robCafe1 money5))

    	(not (have_money robCafe2 money1)) (not (have_money robCafe2 money2))
        (not (have_money robCafe2 money3)) (not (have_money robCafe2 money4))
        (not (have_money robCafe2 money5))

        ;;predicato che associa i drink ai distributori
    	(have_drink ds1 coffee1) (have_drink ds1 coffee2)
        (have_drink ds2 coffee3) (have_drink ds3 coffee3)
    	(have_drink ds1 chocolate1) (have_drink ds2 chocolate2)
        (have_drink ds2 the1) (have_drink ds2 the2)
        (have_drink ds3 the3) (have_drink ds3 the4)
        (have_drink ds3 the5)

        ;;specifico bancomat e stanza
    	(bancomat banc1 s2)
    	(bancomat banc2 s8)

        ;;specifico le posizioni iniziali degli individui
    	(at robCafe1 s9)
        (at robCafe2 s1)
    	(at man1 s5)
    	(at man2 s15)
        (at man3 s24)

        (at ds1 s3)
        (at ds2 s9)
        (at ds3 s15)
    )

    (:goal
        (and
            (take_drink man1 the1)
            (take_drink man2 chocolate1)
        	(have_money robCafe1 money1)
        	(have_money robCafe1 money2)
        	(have_money robCafe1 money3)
        	(have_money robCafe1 money4)
        	(have_money robCafe1 money5)
        	(have_money man1 money1)
            (have_money robCafe2 money3)
        )
    )
)
