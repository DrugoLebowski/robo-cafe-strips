(define (domain robotCafeX)
	(:requirements :strips :equality :typing)
	(:types Robot Deliever Coffe)
 	(:predicates
		;; Specifica che una locazione è una stanza
		(floor ?loc)

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

		;; Specifica che un oggetto è di tipo ent
		;; (vero sse ?indiv è un'entità)
		(ent ?indiv)

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
		(distr ?ds)

		;; Specifica una carta del bancomat
		(card ?card)

		;; Specifica un pin della carta
		(pin ?pin)

		;; Specifica che un oggetto è di tipo command
		(command ?command)

		;; Specifica l'associazione carta/pin
		(card_pin ?card ?pin)

		;;condizione che un individuo ha soldi (per prelevare, per inserire nel ditributore, per pagare,...)
		(have_money ?ent ?money)

		;;condizione che un distributore ha bevanda
		(have_drink ?ds ?drink)

		;;condizione con cui un individuo prende il drink (goal)
		;;il goal si deve aggiornare con l'aggiunta dell'interazione man robot
		(take_drink ?ent ?drink)

		;;condizione che distingue individui robot da individui man
		(is_human ?indiv)

		;; Condiziona un distributore dall'essere occupato o no
		(occupied_distr ?ds)

		;; Collega un drink con l'entità che l'ha ordinato
		(ordered_drink ?ent ?drink)

		;; Collega un ordine di un individuo con un particolare robot
		(orderer ?indiv ?rob)

		;; Condiziona un individuo, facendo in modo che per prelevare debba essere
		;; in possesso della carta del bancomat
		(have_card ?indiv ?card)

		;; Condiziona ulteriormente un individuo a possedere, oltre alla carta,
		;; anche il pin ad essa associato
		(have_pin ?indiv ?pin)

		;; Condiziona l'entità che possono prendere le bibite dal distributore
		(have_command ?ent ?command)

		;; Condiziona il robot dal comando dell'uomo che ha richiesto una bevanda
		(commanded_by ?rob ?man)

		;; Condiziona la disponibilità del robot
		(available ?rob)

		;; Condiziona il pagamento tra uomo e robot
		(have_paid ?man ?rob)

		;; Condiziona la consegna della bevanda da parte del robot all'uomo
		(delivered ?rob ?man)

		;; Condiziona le entità che possono ordinare
		(can_order ?ent)

		;; Condiziona il pagamento
		(paid ?ent)

		;; Condiziona un'entità a restare in una posizione
		(lock ?ent)
 	)

	;; Azione che permette lo spostamento di un'entità (uomo/robot)
	;; tra due stanze dello stesso piano
	(:action move
		:parameters (?indiv ?loc1 ?loc2)
		:precondition (
			and
				(ent ?indiv)
       			(at ?indiv ?loc1)
       			(conn ?loc1 ?loc2)
				(not (lock ?indiv))
		)
   		:effect (
			and
				(at ?indiv ?loc2)
			 	(not (at ?indiv ?loc1))
		)
  	)

	;; Azione che permette lo spostamento di un individuo tra due stanze
	;; tramite le scale
	(:action climb
		:parameters (?indiv ?st ?loc1 ?loc2)
		:precondition (
			and
				(ent ?indiv)
	   			(at ?indiv ?loc1)
				(stairs ?st ?loc1)
				(climb ?loc1 ?loc2)
				(not (lock ?indiv))
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
				(ent ?ent)
				(distr ?ds)
				(money ?money)

				(at ?ds ?loc) (at ?ent ?loc)
				(have_money ?ent ?money)
				(have_drink ?ds ?drink)
				(not (occupied_distr ?ds))
				(can_order ?ent)
    	)
    	:effect (
			and
				(at ?ent ?ds) (not (at ?ent ?loc))
				(occupied_distr ?ds)
				(have_money ?ds ?money) (not (have_money ?ent ?money))
				(ordered_drink ?ent ?drink)
    	)
	)

	;; Azione che permette ad un'entità (uomo/robot) prende il drink ordinato
	;; precedentemente dal distributore
	(:action push_drink
	    :parameters (?ent ?ds ?loc ?drink)
	    :precondition (
			and
				(ent ?ent)
	            (distr ?ds)
				(at ?ds ?loc)
				(at ?ent ?ds)
				(occupied_distr ?ds)
				(ordered_drink ?ent ?drink)
	    )
	    :effect (
			and
				(at ?ent ?loc) (not (at ?ent ?ds))
				(not (occupied_distr ?ds))
	            (take_drink ?ent ?drink)
		    	(not (have_drink ?ds ?drink))
				(not (ordered_drink ?ent ?drink))
	    )
	)

	;; Azione che permette ad un uomo di ritirare i soldi da un bancomat
	(:action withdraw
	    :parameters (?ent ?money ?card ?pin ?banc ?loc)
	    :precondition (
			and
				(ent ?ent)
				(card ?card)
				(pin ?pin)
				(money ?money)
				(bancomat ?banc ?loc)

				(at ?ent ?loc)
			    (is_human ?ent)
				(have_card ?ent ?card)
				(have_pin ?ent ?pin)
				(card_pin ?card ?pin)
				(have_money ?banc ?money)
			    (not (have_money ?ent ?money))
	    )
	    :effect (
			and
		    		 (have_money ?ent ?money)
				(not (have_money ?banc ?money))
	    )
	)

	;; Azione che permette ad un uomo di dare i soldi ad un robot che non ne ha
	(:action pay_before
	   :parameters (?man ?rob ?money ?loc)
	   :precondition (
	   		and
				(at ?rob ?loc) (at ?man ?loc)
				(is_human ?man) (not (is_human ?rob))
				(have_money ?man ?money) (not (have_money ?rob ?money))

				(not (delivered ?rob ?man))
				(commanded_by ?rob ?man)
	   )
	   :effect (
	   		and
				(have_money ?rob ?money) (not (have_money ?man ?money))
				(paid ?man)
		)
	)

	(:action pay_after
	   :parameters (?man ?rob ?money ?loc)
	   :precondition (
	   		and
				(ent ?rob) (ent ?man)
				(is_human ?man)	(not (is_human ?rob))

				(at ?rob ?loc) (at ?man ?loc)
				(have_money ?man ?money) (not (have_money ?rob ?money))

				(not (commanded_by ?rob ?man))
				(available ?rob)
				(delivered ?rob ?man)
				(not (paid ?man))
	   )
	   :effect (
	   		and
				(not (delivered ?rob ?man))
				(have_money ?rob ?money) (not (have_money ?man ?money))
		)
	)

	;; Azione che permette ad un robot di consegnare il prodotto ordinato da un uomo
	(:action deliver
		:parameters (?rob ?man ?drink ?loc)
		:precondition (
			and
				(ent ?rob) (ent ?man)
				(is_human ?man) (not (is_human ?rob))

				(at ?rob ?loc) (at ?man ?loc)
				(take_drink ?rob ?drink) (not (take_drink ?man ?drink))
				(commanded_by ?rob ?man)
				(not (available ?rob))
				(not (delivered ?rob ?man))
		)
		:effect (
			and
				(delivered ?rob ?man)
				(take_drink ?man ?drink) (not (take_drink ?rob ?drink))
				(not (commanded_by ?rob ?man))
				(available ?rob)
				(not (can_order ?rob))
		)
	)

	(:action call_robot
		:parameters (?man ?rob ?money ?loc)
		:precondition (
			and
				(floor ?loc)
				(ent ?man) (ent ?rob)
				(is_human ?man) (not (is_human ?rob))

				(at ?man ?loc)
				(not (can_order ?man)) (not (can_order ?rob))
				(available ?rob) (have_money ?man ?money)
		)
		:effect (
			and
				(lock ?man)
				(commanded_by ?rob ?man)
				(not (available ?rob))
				(can_order ?rob)
				(not (delivered ?rob ?man))
		)
	)
)
