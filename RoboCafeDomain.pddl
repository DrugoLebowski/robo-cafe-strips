(define (domain robotCafeX)
	(:requirements Strips :equality :typing)
	(:types Robot Deliever Coffe)
 	(:predicates

        ; TEAM : AgentRobotX
		; MEMBER:
        ;     Alessandro Bigiotti Matr. 281812
		;     Valerio Belli Matr. 283514

		;; Specifica che una locazione è una stanza
		(room ?loc)

		;; Specifica la connessione tra due stanze (vero sse loc1 connesso con loc2)
		(conn ?loc1 ?loc2)

		;; Specifica la connessione tra due ascensori (vero sse l1 conn l2)
		(asc ?l1 ?l2)

		;; Specifica che un ascensore è possibile prenderlo in una specifica
		;; posizione (vero sse ?l è posizionato in ?loc)
		(take_asc ?l ?loc)

		;; Specifica che un'entità è posizionata in una cerca locazione
		;; (vero sse ?indiv è nella posizione ?loc)
		(at ?indiv ?loc)

		;; Specifica che un oggetto è un'entità
		(ent ?ent)

		;; Specifica che un oggetto è un uomo
		;; (vero sse ?indiv è un'uomo)
		(man ?man)

		; Specifica che un oggetto è un robot
		; (vero sse ?rob è un robot)
		(robot ?robot)

		;; Specifica che un oggetto è di tipo money
		(money ?money)

		;; Specifica che un oggetto è di tipo drink
  		(drink ?drink)

		;; Specifica che un oggetto di tipo scale si trova nella posizione ?loc
		;; (vero sse ?st se è di tipo stairs e se si trovano nella posizione ?loc)
		(stairs ?st ?loc)

		;;specifica il bancomat banc nella stanza loc
		(bancomat ?banc ?loc)

		;; individuo si sposta tra le stanze loc1 loc2 con le scale
		(climb ?loc1 ?loc2)

		;;specifica un distributore ds nella stanza loc
		(distributor ?ds)

		;; Specifica una carta del bancomat
		(card ?card)

		;; Specifica un pin della carta
		(pin ?pin)

		;; Specifica l'associazione carta/pin
		(card_pin ?card ?pin)

		;;condizione che un individuo ha soldi (per prelevare, per inserire nel ditributore, per pagare,...)
		(have_money ?ent ?money)

		(with_money ?ent)

		;;condizione che un distributore ha bevanda
		(have_drink ?ds ?drink)

		;;condizione con cui un individuo prende il drink (goal)
		;;il goal si deve aggiornare con l'aggiunta dell'interazione man robot
		(take_drink ?ent ?drink)

		;; Condiziona un distributore dall'essere occupato o no
		(occupied_distributor ?ds)

		;; Collega un drink con l'entità che l'ha ordinato da un distributore
		(ordered_drink_from_distr ?ent ?drink ?ds)

		(ordered_drink ?ent ?drink)

		;; Collega un ordine di un individuo con un particolare robot
		(orderer ?indiv ?rob ?drink)

		;; Condiziona un individuo, facendo in modo che per prelevare debba essere
		;; in possesso della carta del bancomat
		(have_card ?indiv ?card)

		;; Condiziona ulteriormente un individuo a possedere, oltre alla carta,
		;; anche il pin ad essa associato
		(have_pin ?indiv ?pin)

		;; Condiziona la disponibilità del robot
		(available ?rob)

		;; Condiziona il pagamento tra uomo e robot
		(have_paid ?man ?rob)

		;; Condiziona le entità che possono ordinare
		(can_order ?ent)

		; Condiziona l'inizio di un ordine
		(init_order ?man ?rob)

		; Condiziona il pay_after con il pay_before
		(paid ?man ?rob ?drink)

		(active_call ?man ?rob ?drink)

		(delivered ?drink)

		(lock ?man)
 	)

	;; Azione che permette lo spostamento di un'entità (uomo/robot)
	;; tra due stanze dello stesso piano
	(:action move
		:parameters (?entity ?loc1 ?loc2)
		:precondition (
			and
				(ent ?entity)
				(room ?loc1) (room ?loc2)

				(not (lock ?entity))
       			(at ?entity ?loc1)
       			(conn ?loc1 ?loc2)
		)
   		:effect (
			and
				(at ?entity ?loc2)
			 	(not (at ?entity ?loc1))
		)
  	)

	;; Azione che permette lo spostamento di un individuo tra due stanze
	;; tramite le scale
	(:action climb
		:parameters (?indiv ?st ?loc1 ?loc2)
		:precondition (
			and
				(ent ?indiv)
				(room ?loc1) (room ?loc2)
				(stairs ?st ?loc1)
				(not (lock ?indiv))

	   			(at ?indiv ?loc1)
				(climb ?loc1 ?loc2)
		)
		:effect (
			and
		        (at ?indiv ?loc2)
		        (not (at ?indiv ?loc1))
		)
	)

	;; Azione che permette ad un'entità (uomo/robot) di entrare in ascensore
	(:action enter
		:parameters (?indiv ?loc ?l)
		:precondition (
			and
				(ent ?indiv)
				(room ?loc)
		        (take_asc ?l ?loc)
		        (at ?indiv ?loc)
				(not (lock ?indiv))
		)
		:effect (
			and
		        (at ?indiv ?l)
		        (not (at ?indiv ?loc))
		)
 	)

	;; Azione che permette ad un'entità (uomo/robot) di selezionare
	;; il piano in cui scendere (seleziona l'ascensore che è collegato ad un piano)
	(:action push_lift
		:parameters (?indiv ?l1 ?l2)
		:precondition (
			and
    			(ent ?indiv)
		        (at ?indiv ?l1)
    			(asc ?l1 ?l2)
		)
		:effect (
			and
    			(at ?indiv ?l2)
		        (not (at ?indiv ?l1))
		)
	)

	;; Azione che permette ad un'entità di uscire dall'ascensore nella stanza
	;; selezionata precedentemente
	(:action exit
		:parameters (?indiv ?l ?loc)
		:precondition (
			and
				(ent ?indiv )
				(room ?loc)
				(take_asc ?l ?loc)
				(at ?indiv ?l)
		)
		:effect (
			and
		        (at ?indiv ?loc)
				(not (at ?indiv ?l))
		)
	)



	;; Azione che permette ad un'entità (uomo/robot) di inserire i soldi nel
	;; distributore e sceglie la bevanda
	(:action insert_money
		:parameters (?ent ?ds ?loc ?money ?drink)
		:precondition (
			and
				(ent ?ent) (man ?ent)
				(distributor ?ds)
				(money ?money)
				(room ?loc)

				(at ?ds ?loc) (at ?ent ?loc)
				(have_money ?ent ?money)
				(have_drink ?ds ?drink)
				(not (occupied_distributor ?ds))
				(can_order ?ent)
    	)
    	:effect (
			and
				(at ?ent ?ds) (not (at ?ent ?loc))
				(occupied_distributor ?ds)
				(not (have_money ?ent ?money))
				(ordered_drink_from_distr ?ent ?drink ?ds)
    	)
	)

	(:action insert_money_rob
		:parameters (?man ?rob ?ds ?loc ?money ?drink)
		:precondition (
			and
				(man ?man) (robot ?rob)
				(distributor ?ds)
				(money ?money)
				(room ?loc)

				(at ?ds ?loc) (at ?rob ?loc)
				(have_money ?rob ?money)
				(have_drink ?ds ?drink)
				(not (occupied_distributor ?ds))
				(can_order ?rob)
				(orderer ?man ?rob ?drink)
		)
		:effect (
			and
				(at ?rob ?ds) (not (at ?rob ?loc))
				(occupied_distributor ?ds)
				(not (have_money ?rob ?money))
				(ordered_drink_from_distr ?rob ?drink ?ds)
		)
	)

	;; Azione che permette ad un'entità (uomo/robot) prende il drink ordinato
	;; precedentemente dal distributore
	(:action push_drink
	    :parameters (?ent ?ds ?loc ?drink)
	    :precondition (
			and
				(ent ?ent)
	            (distributor ?ds)
				(room ?loc)

				(at ?ds ?loc) (at ?ent ?ds)
				(occupied_distributor ?ds)
				(ordered_drink_from_distr ?ent ?drink ?ds)
	    )
	    :effect (
			and
				(at ?ent ?loc) (not (at ?ent ?ds))
				(not (occupied_distributor ?ds))
	            (take_drink ?ent ?drink)
		    	(not (have_drink ?ds ?drink))
				(not (ordered_drink_from_distr ?ent ?drink ?ds))
	    )
	)

	;; Azione che permette ad un uomo di ritirare i soldi da un bancomat
	(:action withdraw
	    :parameters (?entity ?money ?card ?pin ?banc ?loc)
	    :precondition (
			and
				(man ?entity)
				(card ?card)
				(pin ?pin)
				(money ?money)
				(bancomat ?banc ?loc)
				(room ?loc)

				(at ?entity ?loc)
				(have_card ?entity ?card)
				(have_pin ?entity ?pin)
				(card_pin ?card ?pin)
				(have_money ?banc ?money) (not (have_money ?entity ?money))
	    )
	    :effect (
			and
    		 	(have_money ?entity ?money) (not (have_money ?banc ?money))
	    )
	)

	;; Azione che permette ad un uomo di dare i soldi ad un robot che non ne ha
	(:action pay_before
	   :parameters (?man ?rob ?money ?drink ?loc)
	   :precondition (
	   		and
				(man ?man)
				(robot ?rob)
				(money ?money)
				(room ?loc)
				(drink ?drink)

				(at ?rob ?loc) (at ?man ?loc)
				(orderer ?man ?rob ?drink)
				(not (paid ?man ?rob ?drink))
				(not (take_drink ?rob ?drink)) (not (take_drink ?man ?drink))
	   )
	   :effect (
	   		and
				(paid ?man ?rob ?drink)
				(not (have_money ?man ?money)) (have_money ?rob ?money)
		)
	)

	(:action pay_after
	   :parameters (?man ?rob ?money ?drink ?loc)
	   :precondition (
	   		and
				(man ?man)
				(robot ?rob)
				(room ?loc)
				(money ?money)
				(drink ?drink)

				(at ?rob ?loc) (at ?man ?loc)
				(orderer ?man ?rob ?drink)
				(not (paid ?man ?rob ?drink))
				(take_drink ?rob ?drink) (not (take_drink ?man ?drink))
   		)
	   :effect (
	   		and
				(paid ?man ?rob ?drink)
				(have_money ?rob ?money) (not (have_money ?man ?money))
		)
	)

	;; Azione che permette ad un robot di consegnare il prodotto ordinato da un uomo
	(:action deliver
		:parameters (?rob ?man ?drink ?loc)
		:precondition (
			and
				(man ?man)
				(robot ?rob)
				(room ?loc)
				(drink ?drink)

				(at ?rob ?loc) (at ?man ?loc)
				(take_drink ?rob ?drink) (not (take_drink ?man ?drink))
				(not (available ?rob))
				(not (delivered ?drink))
				(orderer ?man ?rob ?drink)
		)
		:effect (
			and
				(delivered ?drink)
				(take_drink ?man ?drink) (not (take_drink ?rob ?drink))
				(not (can_order ?rob))
				(available ?rob)
				(not (lock ?man))
				(not (orderer ?man ?rob ?drink))
		)
	)

	(:action call_robot
		:parameters (?man ?rob ?loc ?drink)
		:precondition (
			and
				(man ?man)
				(robot ?rob)
				(room ?loc)

				(at ?man ?loc)
				(not (can_order ?man)) (not (can_order ?rob))
				(available ?rob)
		)
		:effect (
			and
				(not (delivered ?drink))
				(not (available ?rob))
				(can_order ?rob)
				(orderer ?man ?rob ?drink)
				(lock ?man)
		)
	)
)
