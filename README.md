<p align= "center">
<img src = "https://github.com/LorenzoTanga-bot/DOIT/blob/master/frontend/assets/images/logo.png"> 
</p>

---

<p align= "center">  
<b>DOIT</b> , progetto realizzato in <b>Flutter</b> e <b>Spring-Boot</b> per il corso di laurea <b>L-31</b> presso <b>Università di Camerino</b>, nell’anno accademico <b>2020/2021</b>, realizzato dagli studenti <b>Alessandra Lerteri Caroletta</b>, <b>Luigi Amura</b> e <b>Lorenzo Tanganelli</b> per gli esami di <b>Ingegneria del Software</b> e <b>Progettazione di Applicazioni Web e Mobile</b> seguendo i canoni di sviluppo proposti.
</p>
<br>

# Contenuti
1. [Panoramica e funzionalità di base](#panoramica) 
2. [Tecnologie utilizzate durante lo sviluppo](#tecnologie)
3. [Manuale utente](#manuale)
4. [Iterazioni future](#iterazioni)
5. [Autori](#autori)
<br><br>

# Panoramica e Funzionalità di base <a name = "panoramica" > </a>
Lo scopo dell’applicativo proposto è quello di <b>promuovere lo svolgimento collaborativo</b> di progetti e facilitarne l’inserimento di progettisti sulla base delle loro competenze. <br>
Il sistema vuole inoltre realizzare una <b>vetrina di progetti</b> pubblicati per dare la possibilità a tutti gli utenti di vedere quali sono attualmente proposti e quali lo sono stati. <br> <br>
I ruoli ricoperti dagli utenti nell’applicativo sono : <i>proponenti</i> di progetto, <i>progettisti</i> ed <i>esperti</i>. <br> <br>
Ogni progetto proposto, ha una <b>data di inizio</b> e una di <b>fine candidature</b>, periodo di tempo durante il quale i progettisti hanno la possibilità di candidarsi o di essere invitati a collaborare.<br>
Il proponente inoltre, per ogni progetto può specificare se quest’ultimo ha <b>abilitate le valutazioni</b> e, in caso affermativo, gli esperti (sempre sulla base delle loro competenze) possono rilasciare valutazioni al progetto stesso o, se presente, alla cordata che lo porterà a compimento.<br> <br>
I <i>proponenti</i> di progetto sono <b>enti</b> che vogliono inserire proposte di progetto ed avere la possibilità di invitare progettisti a collaborare al progetto.
<br>
I <i>progettisti</i> sono <b>persone</b> o <b>enti</b> che hanno specifiche competenze, il loro scopo è quello di partecipare a progetti. <br>  Questi ultimi possono partecipare ad un progetto solamente se hanno almeno una delle competenze richieste per il progetto.<br>
Gli <i>esperti</i> sono <b>persone</b> che possono valutare proposte di progetto oppure i team che li sviluppano.<br><br>
Gli utenti registrati come persone fisiche possono essere dei progettisti e/o degli esperti, mentre gli utenti registrati come enti possono ricoprire il ruolo di proponente di progetto e/o di progettista.<br><br>

# Tecnologie utilizzate durante lo Sviluppo <a name = "tecnologie" > </a>

Il lato <b>Frontend</b> dell’applicativo si rivolge (momentaneamente solo) al mondo iOS ed è stato sviluppato mediante il framework <b>Open Source Flutter</b> e il relativo linguaggio di programmazione <b>Dart</b>.<br> 
Per separare lo stato dell’applicazione dall’interfaccia utente e per gestire la ricostruzione dell’albero dei widget in base ai cambiamenti di stato è stato implementato il pacchetto <b>Provider</b>. <br> <br>
Il lato <b>Backend</b> del sistema è stato sviluppato in <b>Java</b> con il supporto del framework <b>Spring-Boot</b> a cui è stato affidato il compito di scrivere e gestire le <b>API Rest</b>, anche per quanto riguarda la sicurezza.<br> <br>
Per la persistenza dei dati ci si affida al database non relazionale <b>MongoDB Atlas</b>.<br> <br>
Per rendere più agevole la scrittura del codice è stata implementata la libreria java <b>Lombok</b>, così da poter scrivere specifici metodi attraverso annotazioni.<br> <br>
Per fornire credenziali di accesso tra client e server è stato utilizzato inizialmente il metodo “Basic access authentication”, il quale sfrutta l’header delle richieste HTTP per trasmettere ID e password codificati in Base64.<br> In una successiva iterazione si è deciso di rendere più sicura la nostra applicazione e di sfruttare lo standard dei <b>JWT</b> (JSON Web Token). <br> <br>
La modellazione del sistema è stata fatta secondo il processo iterativo ed incrementale Unified Process. <br>
Nella cartella [DOCUMENTAZIONE](/Documentazione) si possono osservare i modelli sviluppati e come si è proceduto durante le varie iterazioni del processo.
<br><br>

#  Manuale utente  <a name = "manuale" > </a>

Ogni utente, in base al ruolo con cui si è registrato, visualizzerà una schermata personalizzata e potrà compiere azioni diverse. <br>

* Il **Proponente di progetto** potrà:
    - Creare nuovi progetti e successivamente modificarli.
    - Accedere alla lista dei progetti da lui proposti.
     - Visualizzare le candidature arrivategli dai progettisti e per ognuna di esse può scegliere di accettare o rifiutare la collaborazione.
    - Visualizzare gli inviti mandati a progettisti e gli inviti arrivategli dai progettisti (enti) per far partecipare, ad un suo progetto, un progettista (persona).
    - Per ogni invito arrivatogli da un progettista (ente) può scegliere di accettare o rifiutare la collaborazione del progettista (persona). 
    <br> <br>
* Il **Progettista** potrà:
    - Candidarsi ad un progetto
    - Visualizzare la lista delle candidature inoltrate
    - Visualizzare la lista di inviti ricevuti a partecipare ad un progetto
    - Visualizzare la lista di inviti inoltrati a progettisti (persone) per partecipare ad un progetto (opzione disponibile solo nel caso in cui il progettista sia un ente)
     - Rispondere a inviti ricevuti
     - Visualizzare la lista dei progetti a cui si partecipa o si è partecipato
    - Visualizzare la lista delle valutazioni ricevute 
    <br> <br>
* L’ **Esperto** potrà:
    - Valutare un progetto
    - Valutare i collaboratori di un progetto
    - Visualizzare la lista di valutazioni rilasciate a progetti
    - Visualizzare la lista di valutazioni rilasciate a team <br>

Nella cartella [SCREEN APP](/Screen%20App) si possono vedere alcune schermate che differenziano i vari utenti. <br> <br>
Tutte le operazioni che riguardano l’invio di inviti, l’invio di candidature e il rilascio di valutazioni, vengono effettuate sulla base della corrispondenza delle competenze dell’utente con quelle del progetto su cui si vuole eseguire una determinata azione. <br> <br>
Un utente non registrato potrà solamente visualizzare i progetti pubblicati, ricercarli e visualizzare e ricercare i profili dei vari utenti.  <br> Un qualsiasi utente registrato potrà, oltre alle azione disponibili all'utente non registrato, creare dei specifici tag che non sono presenti nel sistema.<br> <br>
N.B. le valutazioni rilasciate sono anonime in quanto non è visibile il nome dell’esperto che l’ha rilasciata. <br>
Il profilo dell’esperto non è visibile agli utenti. 
<br> <br>

#  Iterazioni future  <a name = "iterazioni" > </a>

Nelle successive iterazioni è prevista l'aggiunta delle notifiche per gli utenti. <br>
Potranno essere inviate delle  notifiche quando si riceve una nuova candidatura ad un progetto, un nuovo invito a collaborare, o una valutazione. <br>
L'aggiunta di questo nuovo meccanismo permetterà una più facile interazione con l'app in quanto si verrà avvisati in tempo reale delle novità più rilevanti del proprio profilo (o del propio progetto). <br> <br>
Si prevede anche l'introduzione dell'avatar per l'utente: chi è registrato all'applicaione potrà aggiungere alle proprie informazioni una foto. <br> <br>
Altro punto focale della prossima iterazione sarà di rivedere il codice per essere adatto -nel lato estetico- a stare su una piattaforma android. <br> <br>
In ultimo è pianificato l'inserimento per la parte riguardante le statistiche. <br> Ogni utente registrato potra vedere sia statistiche globali (quali sono ad esempio gli ambiti di applicazione -tag- in cui ci sono più progetti) che statistiche singole, proprie ( ad esempio vedere quanti e in quali progetti ha collaborato nell'ultimo anno).
<br><br>


# Autori <a name = "autori" > </a>
* [Alessandra Lerteri Caroletta](https://github.com/Leerti)
* [Lorenzo Tanganelli](https://github.com/LorenzoTanga-bot)
* [Luigi Amura](https://github.com/Louam-dev)

