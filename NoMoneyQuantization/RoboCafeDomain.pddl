(define (domain robotCafeX)
	(:requirements :strips :equality :typing)
	(:types Robot Deliever Coffe)
 	(:predicates
		;; connette due stanze sullo stesso piano
		(conn ?loc1 ?loc2)

		;;connette gli ascensori
		(asc ?l1 ?l2)

		;;condizione per prendere l'ascensore l al piano loc
		(take_asc ?l ?loc)

		;;condizione che un ente si trova in una stanza
		(at ?indiv ?loc)

		;;specifica che ?indiv e' un ente (rob o man)
		(ent ?indiv)

		;;oggetto drink (the1, coffe1, ...)
  		(drink ?drink)

		;;condizione per salire le scale st dalla stanza loc
		(stairs ?st ?loc)

		;;specifica il bancomat banc nella stanza loc
		(bancomat ?banc ?loc)

		;; individuo si sposta tra le stanze loc1 loc2 con le scale
		(climb ?loc1 ?loc2)

		;; Specifica un distributore
		(distr ?ds)

		;; Specifica una carta del bancomat
		(card ?card)

		;; Specifica un pin della carta
		(pin ?pin)

		;; Specifica l'associazione carta/pin
		(card_pin ?card ?pin)

		;;condizione che un individuo ha soldi (per prelevare, per inserire nel ditributore, per pagare,...)
		(have_money ?ent)

		;;condizione che un distributore ha bevanda
		(have_drink ?ds ?drink)

		;;condizione con cui un individuo prende il drink (goal)
		;;il goal si deve aggiornare con l'aggiunta dell'interazione man robot
		(take_drink ?ent ?drink)

		;;condizione che distingue individui robot da individui man
		(is_human ?indiv)

		;; Condiziona l'inizio dell'operazione di acquisto di una bevanda
		;; imponendo una fine (obiettivo intermedio)
		(init_distr_operation ?indiv)

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
 	)

	;;azione che sposta un individuo tra due stanze dello stesso piano
	(:action move
		:parameters (?indiv ?loc1 ?loc2)
		:precondition (
			and
				(ent ?indiv)
       			(at ?indiv ?loc1)
       			(conn ?loc1 ?loc2)
		)
   		:effect (
			and
				(at ?indiv ?loc2)
			 	(not (at ?indiv ?loc1))
		)
  	)

	;;azione che sposta un individuo tra due stanze tramite le scale
	(:action climb
		:parameters (?indiv ?stairs ?loc1 ?loc2)
		:precondition (
			and
				(ent ?indiv)
	   			(at ?indiv ?loc1)
				(stairs ?stairs ?loc1)
				(climb ?loc1 ?loc2)
		)
		:effect (
			and
		        (at ?indiv ?loc2)
		        (not (at ?indiv ?loc1))
		)
	)

	;;individuo entra in ascensore
	(:action enter
		:parameters (?indiv ?loc ?lift)
		:precondition (
			and
				(ent ?indiv)
		        (take_asc ?lift ?loc)
		        (at ?indiv ?loc)
		)
		:effect (
			and
		        (at ?indiv ?lift)
		        (not (at ?indiv ?loc))
		)
 	)

	;;seleziona il piano in cui scendere (seleziona l'ascensore che e' collegato ad un piano)
	(:action push_lift
		:parameters (?indiv ?lift1 ?lift2)
		:precondition (
			and
    			(ent ?indiv)
		        (at ?indiv ?lift1)
    			(asc ?lift1 ?lift2)
		)
		:effect (
			and
    			(at ?indiv ?lift2)
		        (not (at ?indiv ?lift1))
		)
	)

	;;esce dall'ascensore nella stanza loc
	(:action exit
		:parameters (?indiv ?lift ?loc)
		:precondition (
			and
				(ent ?indiv )
				(take_asc ?lift ?loc)
				(at ?indiv ?lift)
		)
		:effect (
			and
		        (at ?indiv ?loc)
				(not (at ?indiv ?lift))
		)
	)

	;;inserisce soldi nel ditributore
	(:action insert_money
		:parameters (?ent ?ds ?drink ?loc)
		:precondition (
			and
				(ent ?ent)
				(distr ?ds)
				(at ?ds ?loc)
				(at ?ent ?loc)
				(have_money ?ent)
				(have_drink ?ds ?drink)
				(not (init_distr_operation ?ent))
    	)
    	:effect (
			and
				(ordered_drink ?ent ?drink)
				(init_distr_operation ?ent)
				(have_money ?ds)
		        (not (have_money ?ent))
    	)
	)

	;;seleziona il drink da prendere
	(:action push_drink
	    :parameters (?ent ?ds ?drink ?loc)
	    :precondition (
			and
				(ent ?ent)
	            (distr ?ds)
				(at ?ds ?loc)
				(at ?ent ?loc)
				(init_distr_operation ?ent)
				(ordered_drink ?ent ?drink)
	    )
	    :effect (
			and
				(not (init_distr_operation ?ent))
	            (take_drink ?ent ?drink)
		    	(not(have_drink ?ds ?drink))
				(not (ordered_drink ?ent ?drink))
	    )
	)

	;;man ritira i soldi da un bancomat in una stanza
	(:action withdraw
	    :parameters (?ent ?card ?pin ?banc ?loc)
	    :precondition (
			and
				(ent ?ent)
			    (bancomat ?banc ?loc)
				(card ?card)
				(pin ?pin)

				(at ?ent ?loc)
			    (is_human ?ent)
				(have_card ?ent ?card)
				(have_pin ?ent ?pin)
				(card_pin ?card ?pin)
				(not (have_money ?ent))
	    )
	    :effect (
			and
		    	(have_money ?ent)
	    )
	)

	;;man da soldi a robot senza soldi
	(:action pay
	   :parameters (?man ?rob ?loc)
	   :precondition (
	   		and
				(at ?rob ?loc)
				(at ?man ?loc)
				(is_human ?man)
				(not (is_human ?rob))
				(not (have_money ?rob))
				(have_money ?man)
				(not (orderer ?man ?rob))
	   )
	   :effect (
	   		and
				(orderer ?man ?rob)
				(have_money ?rob)
				(not (have_money ?man))
		)
	)

	(:action deliver
		:parameters (?rob ?man ?drink ?loc)
		:precondition (
			and
				(ent ?rob)
				(ent ?man)
				(is_human ?man)
				(not (is_human ?rob))

				(at ?rob ?loc)
				(at ?man ?loc)

				(take_drink ?rob ?drink)
				(not (take_drink ?man ?drink))

				(orderer ?man ?rob)
		)
		:effect (
			and
				(take_drink ?man ?drink)
				(not (take_drink ?rob ?drink))
				(not (orderer ?man ?rob))
		)
	)
)
