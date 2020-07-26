# MySQL on Mac w/ Python

This is a how-to on installing [MySQL](https://dev.mysql.com/doc/), creating a simple database, and interacting with it through [Python](https://docs.python.org/3/).

## Create a MySQL database from a .CSV file

The .CSV is exported from [pioneers.computer](https://docs.google.com/spreadsheets/d/19DvX7gVPpk3PccgRNH2sW9OjG7NhGuh8OjLFRs0v6ck/). It is based on the [Wikipedia](https://en.wikipedia.org) [list of pioneers in computer science](https://en.wikipedia.org/wiki/List_of_pioneers_in_computer_science). Here are the steps to follow:

- Install [MySQL](https://dev.mysql.com/doc/) (I use [Homebrew](https://docs.brew.sh/)).

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`brew install mysql # already installed!`</span>

```
Warning: mysql 8.0.21 is already installed and up-to-date
To reinstall 8.0.21, run `brew reinstall mysql`
```

- Start the  [MySQL](https://dev.mysql.com/doc/) server.

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql.server start`</span>

```
Starting MySQL
.. SUCCESS! 
```

- Create the `'mysql'@'localhost'` user, granting all privileges.

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`sudo mysql`</span><br>
<span style="color:green;">`Password:`</span>

```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.21 Homebrew

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE USER 'mysql'@'localhost' IDENTIFIED BY 'mysql';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL PRIVILEGES ON *.* TO 'mysql'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)
```

- Include a [`~/.my.cnf`](https://medium.com/@andrewpongco/solving-the-mysql-server-is-running-with-the-secure-file-priv-option-so-it-cannot-execute-this-d319de864285) file so that `LOAD DATA INFILE` will work.

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`cat ~/.my.cnf`</span>

```
[mysqld]
secure_file_priv	= ''
```

- Create the database, table, and load the .CSV data w/ the following .SQL file.

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`cat src/mysql.sql`</span>

```sql
CREATE DATABASE IF NOT EXISTS test;
USE test;

DROP TABLE IF EXISTS pioneers;
CREATE TABLE pioneers (
    last_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NULL,
    gender CHAR(1) NOT NULL,
    first_year SMALLINT NOT NULL,
    email_school VARCHAR(255) NOT NULL,
    email_gmail VARCHAR(255) NOT NULL
);

LOAD DATA INFILE '~/work/mysql-example/data/pioneers.computer.csv'
    INTO TABLE pioneers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;

SHOW TABLES;
SHOW COLUMNS FROM pioneers;
SELECT * FROM pioneers WHERE gender = "F";
```

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`cat data/pioneers.computer.csv`</span>

```csv
First,Last,Gender,Year1,E-mail,G-Mail
Leonard,Adleman,M,1977,LeonardAdleman@pioneers.computer,"""Leonard Adleman"" <LeonardAdleman@pioneers.computer>,"
Howard,Aiken,M,1944,HowardAiken@pioneers.computer,"""Howard Aiken"" <HowardAiken@pioneers.computer>,"
,Al-Jazari,M,1206,Al-Jazari@pioneers.computer,"""Al-Jazari"" <Al-Jazari@pioneers.computer>,"
,Al-Khwarizmi,M,830,Al-Khwarizmi@pioneers.computer,"""Al-Khwarizmi"" <Al-Khwarizmi@pioneers.computer>,"
Frances,Allen,F,1970,FrancesAllen@pioneers.computer,"""Frances Allen"" <FrancesAllen@pioneers.computer>,"
John,Atanasoff,M,1939,JohnAtanasoff@pioneers.computer,"""John Atanasoff"" <JohnAtanasoff@pioneers.computer>,"
Charles,Babbage,M,1822,CharlesBabbage@pioneers.computer,"""Charles Babbage"" <CharlesBabbage@pioneers.computer>,"
Charles,Bachman,M,1973,CharlesBachman@pioneers.computer,"""Charles Bachman"" <CharlesBachman@pioneers.computer>,"
John,Backus,M,1954,JohnBackus@pioneers.computer,"""John Backus"" <JohnBackus@pioneers.computer>,"
Brothers,Banū Mūsā,M,850,BrothersBanūMūsā@pioneers.computer,"""Brothers Banū Mūsā"" <BrothersBanūMūsā@pioneers.computer>,"
Paul,Baran,M,1964,PaulBaran@pioneers.computer,"""Paul Baran"" <PaulBaran@pioneers.computer>,"
Émile,Baudot,M,1874,ÉmileBaudot@pioneers.computer,"""Émile Baudot"" <ÉmileBaudot@pioneers.computer>,"
Yoshua,Bengio,M,2018,YoshuaBengio@pioneers.computer,"""Yoshua Bengio"" <YoshuaBengio@pioneers.computer>,"
Tim,Berners-Lee,M,1989,TimBerners-Lee@pioneers.computer,"""Tim Berners-Lee"" <TimBerners-Lee@pioneers.computer>,"
Manuel,Blum,M,1995,ManuelBlum@pioneers.computer,"""Manuel Blum"" <ManuelBlum@pioneers.computer>,"
Corrado,Böhm,M,1966,CorradoBöhm@pioneers.computer,"""Corrado Böhm"" <CorradoBöhm@pioneers.computer>,"
George,Boole,M,1847,GeorgeBoole@pioneers.computer,"""George Boole"" <GeorgeBoole@pioneers.computer>,"
Kathleen,Booth,F,1947,KathleenBooth@pioneers.computer,"""Kathleen Booth"" <KathleenBooth@pioneers.computer>,"
Per,Brinch Hansen,M,1969,PerBrinchHansen@pioneers.computer,"""Per Brinch Hansen"" <PerBrinchHansen@pioneers.computer>,"
Fred,Brooks,M,1959,FredBrooks@pioneers.computer,"""Fred Brooks"" <FredBrooks@pioneers.computer>,"
Luitzen,Brouwer,M,1908,LuitzenBrouwer@pioneers.computer,"""Luitzen Brouwer"" <LuitzenBrouwer@pioneers.computer>,"
Vannevar,Bush,M,1930,VannevarBush@pioneers.computer,"""Vannevar Bush"" <VannevarBush@pioneers.computer>,"
David,Caminer,M,1951,DavidCaminer@pioneers.computer,"""David Caminer"" <DavidCaminer@pioneers.computer>,"
Vint,Cerf,M,1978,VintCerf@pioneers.computer,"""Vint Cerf"" <VintCerf@pioneers.computer>,"
Noam,Chomsky,M,1956,NoamChomsky@pioneers.computer,"""Noam Chomsky"" <NoamChomsky@pioneers.computer>,"
Alonzo,Church,M,1936,AlonzoChurch@pioneers.computer,"""Alonzo Church"" <AlonzoChurch@pioneers.computer>,"
Wesley,Clark,M,1962,WesleyClark@pioneers.computer,"""Wesley Clark"" <WesleyClark@pioneers.computer>,"
Edmund,Clarke,M,1981,EdmundClarke@pioneers.computer,"""Edmund Clarke"" <EdmundClarke@pioneers.computer>,"
John,Cocke,M,1987,JohnCocke@pioneers.computer,"""John Cocke"" <JohnCocke@pioneers.computer>,"
Edgar,Codd,M,1970,EdgarCodd@pioneers.computer,"""Edgar Codd"" <EdgarCodd@pioneers.computer>,"
Lynn,Conway,F,1971,LynnConway@pioneers.computer,"""Lynn Conway"" <LynnConway@pioneers.computer>,"
Stephen,Cook,M,1967,StephenCook@pioneers.computer,"""Stephen Cook"" <StephenCook@pioneers.computer>,"
James,Cooley,M,1965,JamesCooley@pioneers.computer,"""James Cooley"" <JamesCooley@pioneers.computer>,"
Fernando,Corbató,M,1989,FernandoCorbató@pioneers.computer,"""Fernando Corbató"" <FernandoCorbató@pioneers.computer>,"
Ole-Johan,Dahl,M,1962,Ole-JohanDahl@pioneers.computer,"""Ole-Johan Dahl"" <Ole-JohanDahl@pioneers.computer>,"
Donald,Davies,M,1965,DonaldDavies@pioneers.computer,"""Donald Davies"" <DonaldDavies@pioneers.computer>,"
Whitfield,Diffie,M,1976,WhitfieldDiffie@pioneers.computer,"""Whitfield Diffie"" <WhitfieldDiffie@pioneers.computer>,"
Edsger,Dijkstra,M,1968,EdsgerDijkstra@pioneers.computer,"""Edsger Dijkstra"" <EdsgerDijkstra@pioneers.computer>,"
William,Eccles,M,1918,WilliamEccles@pioneers.computer,"""William Eccles"" <WilliamEccles@pioneers.computer>,"
Presper,Eckert,M,1943,PresperEckert@pioneers.computer,"""Presper Eckert"" <PresperEckert@pioneers.computer>,"
Allen,Emerson,M,1981,AllenEmerson@pioneers.computer,"""Allen Emerson"" <AllenEmerson@pioneers.computer>,"
Douglas,Engelbart,M,1963,DouglasEngelbart@pioneers.computer,"""Douglas Engelbart"" <DouglasEngelbart@pioneers.computer>,"
Federico,Faggin,M,1971,FedericoFaggin@pioneers.computer,"""Federico Faggin"" <FedericoFaggin@pioneers.computer>,"
Edward,Feigenbaum,M,1994,EdwardFeigenbaum@pioneers.computer,"""Edward Feigenbaum"" <EdwardFeigenbaum@pioneers.computer>,"
Elizabeth,Feinler,F,1974,ElizabethFeinler@pioneers.computer,"""Elizabeth Feinler"" <ElizabethFeinler@pioneers.computer>,"
Tommy,Flowers,M,1943,TommyFlowers@pioneers.computer,"""Tommy Flowers"" <TommyFlowers@pioneers.computer>,"
Sally,Floyd,F,1994,SallyFloyd@pioneers.computer,"""Sally Floyd"" <SallyFloyd@pioneers.computer>,"
Robert,Floyd,M,1978,RobertFloyd@pioneers.computer,"""Robert Floyd"" <RobertFloyd@pioneers.computer>,"
Gottlob,Frege,M,1879,GottlobFrege@pioneers.computer,"""Gottlob Frege"" <GottlobFrege@pioneers.computer>,"
Stephen,Furber,M,1985,StephenFurber@pioneers.computer,"""Stephen Furber"" <StephenFurber@pioneers.computer>,"
François,Gernelle ,M,1972,FrançoisGernelle@pioneers.computer,"""François Gernelle "" <FrançoisGernelle@pioneers.computer>,"
Seymour,Ginsburg,M,1958,SeymourGinsburg@pioneers.computer,"""Seymour Ginsburg"" <SeymourGinsburg@pioneers.computer>,"
Kurt,Gödel,M,1931,KurtGödel@pioneers.computer,"""Kurt Gödel"" <KurtGödel@pioneers.computer>,"
Shafi,Goldwasser,F,1989,ShafiGoldwasser@pioneers.computer,"""Shafi Goldwasser"" <ShafiGoldwasser@pioneers.computer>,"
Susan,Graham,F,2011,SusanGraham@pioneers.computer,"""Susan Graham"" <SusanGraham@pioneers.computer>,"
Frank,Gray,M,1953,FrankGray@pioneers.computer,"""Frank Gray"" <FrankGray@pioneers.computer>,"
Jim,Gray,M,1974,JimGray@pioneers.computer,"""Jim Gray"" <JimGray@pioneers.computer>,"
Barbara,Grosz,F,1986,BarbaraGrosz@pioneers.computer,"""Barbara Grosz"" <BarbaraGrosz@pioneers.computer>,"
Margaret,Hamilton,F,1971,MargaretHamilton@pioneers.computer,"""Margaret Hamilton"" <MargaretHamilton@pioneers.computer>,"
Richard,Hamming,M,1950,RichardHamming@pioneers.computer,"""Richard Hamming"" <RichardHamming@pioneers.computer>,"
Juris,Hartmanis,M,1993,JurisHartmanis@pioneers.computer,"""Juris Hartmanis"" <JurisHartmanis@pioneers.computer>,"
Anders,Hejlsberg,M,1981,AndersHejlsberg@pioneers.computer,"""Anders Hejlsberg"" <AndersHejlsberg@pioneers.computer>,"
Martin,Hellman,M,1976,MartinHellman@pioneers.computer,"""Martin Hellman"" <MartinHellman@pioneers.computer>,"
Geoffrey,Hinton,M,2008,GeoffreyHinton@pioneers.computer,"""Geoffrey Hinton"" <GeoffreyHinton@pioneers.computer>,"
C.A.R.,Hoare,M,1961,C.A.R.Hoare@pioneers.computer,"""C.A.R. Hoare"" <C.A.R.Hoare@pioneers.computer>,"
Betty,Holberton,F,1968,BettyHolberton@pioneers.computer,"""Betty Holberton"" <BettyHolberton@pioneers.computer>,"
Herman,Hollerith,M,1889,HermanHollerith@pioneers.computer,"""Herman Hollerith"" <HermanHollerith@pioneers.computer>,"
John,Hopcroft,M,1986,JohnHopcroft@pioneers.computer,"""John Hopcroft"" <JohnHopcroft@pioneers.computer>,"
Grace,Hopper,F,1952,GraceHopper@pioneers.computer,"""Grace Hopper"" <GraceHopper@pioneers.computer>,"
Feng-hsiung,Hsu,M,1997,Feng-hsiungHsu@pioneers.computer,"""Feng-hsiung Hsu"" <Feng-hsiungHsu@pioneers.computer>,"
Cuthbert,Hurd,M,1952,CuthbertHurd@pioneers.computer,"""Cuthbert Hurd"" <CuthbertHurd@pioneers.computer>,"
Harry,Huskey,M,1945,HarryHuskey@pioneers.computer,"""Harry Huskey"" <HarryHuskey@pioneers.computer>,"
Kenneth,Iverson,M,1954,KennethIverson@pioneers.computer,"""Kenneth Iverson"" <KennethIverson@pioneers.computer>,"
Joseph-Marie,Jacquard,M,1801,Joseph-MarieJacquard@pioneers.computer,"""Joseph-Marie Jacquard"" <Joseph-MarieJacquard@pioneers.computer>,"
F.W.,Jordan,M,1918,F.W.Jordan@pioneers.computer,"""F.W. Jordan"" <F.W.Jordan@pioneers.computer>,"
William,Kahan,M,1989,WilliamKahan@pioneers.computer,"""William Kahan"" <WilliamKahan@pioneers.computer>,"
Bob,Kahn,M,1978,BobKahn@pioneers.computer,"""Bob Kahn"" <BobKahn@pioneers.computer>,"
Maurice,Karnaugh,M,1970,MauriceKarnaugh@pioneers.computer,"""Maurice Karnaugh"" <MauriceKarnaugh@pioneers.computer>,"
Richard,Karp,M,1985,RichardKarp@pioneers.computer,"""Richard Karp"" <RichardKarp@pioneers.computer>,"
Jacek,Karpinski,M,1973,JacekKarpinski@pioneers.computer,"""Jacek Karpinski"" <JacekKarpinski@pioneers.computer>,"
Alan,Kay,M,1970,AlanKay@pioneers.computer,"""Alan Kay"" <AlanKay@pioneers.computer>,"
Russell,Kirsch,M,1957,RussellKirsch@pioneers.computer,"""Russell Kirsch"" <RussellKirsch@pioneers.computer>,"
Stephen,Kleene,M,1936,StephenKleene@pioneers.computer,"""Stephen Kleene"" <StephenKleene@pioneers.computer>,"
Donald,Knuth,M,1968,DonaldKnuth@pioneers.computer,"""Donald Knuth"" <DonaldKnuth@pioneers.computer>,"
Leslie,Lamport,M,1974,LeslieLamport@pioneers.computer,"""Leslie Lamport"" <LeslieLamport@pioneers.computer>,"
Butler,Lampson,M,1992,ButlerLampson@pioneers.computer,"""Butler Lampson"" <ButlerLampson@pioneers.computer>,"
Sergei,Lebedev,M,1951,SergeiLebedev@pioneers.computer,"""Sergei Lebedev"" <SergeiLebedev@pioneers.computer>,"
Yann,LeCun,M,2018,YannLeCun@pioneers.computer,"""Yann LeCun"" <YannLeCun@pioneers.computer>,"
Gottfried,Leibniz,M,1670,GottfriedLeibniz@pioneers.computer,"""Gottfried Leibniz"" <GottfriedLeibniz@pioneers.computer>,"
J.C.R.,Licklider,M,1960,J.C.R.Licklider@pioneers.computer,"""J.C.R. Licklider"" <J.C.R.Licklider@pioneers.computer>,"
Barbara,Liskov,F,1987,BarbaraLiskov@pioneers.computer,"""Barbara Liskov"" <BarbaraLiskov@pioneers.computer>,"
Ramon,Llull,M,1300,RamonLlull@pioneers.computer,"""Ramon Llull"" <RamonLlull@pioneers.computer>,"
Ada,Lovelace,F,1852,AdaLovelace@pioneers.computer,"""Ada Lovelace"" <AdaLovelace@pioneers.computer>,"
Percy,Ludgate,M,1909,PercyLudgate@pioneers.computer,"""Percy Ludgate"" <PercyLudgate@pioneers.computer>,"
Per,Martin-Löf,M,1971,PerMartin-Löf@pioneers.computer,"""Per Martin-Löf"" <PerMartin-Löf@pioneers.computer>,"
John,Mauchly,M,1943,JohnMauchly@pioneers.computer,"""John Mauchly"" <JohnMauchly@pioneers.computer>,"
John,McCarthy,M,1958,JohnMcCarthy@pioneers.computer,"""John McCarthy"" <JohnMcCarthy@pioneers.computer>,"
Edward,McCluskey,M,1956,EdwardMcCluskey@pioneers.computer,"""Edward McCluskey"" <EdwardMcCluskey@pioneers.computer>,"
Robin,Milner,M,1991,RobinMilner@pioneers.computer,"""Robin Milner"" <RobinMilner@pioneers.computer>,"
Marvin,Minsky,M,1963,MarvinMinsky@pioneers.computer,"""Marvin Minsky"" <MarvinMinsky@pioneers.computer>,"
Yoshirō,Nakamatsu,M,1950,YoshirōNakamatsu@pioneers.computer,"""Yoshirō Nakamatsu"" <YoshirōNakamatsu@pioneers.computer>,"
Satoshi,Nakamoto,M,2008,SatoshiNakamoto@pioneers.computer,"""Satoshi Nakamoto"" <SatoshiNakamoto@pioneers.computer>,"
Akira,Nakashima,M,1934,AkiraNakashima@pioneers.computer,"""Akira Nakashima"" <AkiraNakashima@pioneers.computer>,"
Peter,Naur,M,1960,PeterNaur@pioneers.computer,"""Peter Naur"" <PeterNaur@pioneers.computer>,"
Allen,Newell,M,1956,AllenNewell@pioneers.computer,"""Allen Newell"" <AllenNewell@pioneers.computer>,"
Max,Newman,M,1943,MaxNewman@pioneers.computer,"""Max Newman"" <MaxNewman@pioneers.computer>,"
Kristen,Nygaard,M,1962,KristenNygaard@pioneers.computer,"""Kristen Nygaard"" <KristenNygaard@pioneers.computer>,"
,Pāṇini,M,-500,Pāṇini@pioneers.computer,"""Pāṇini"" <Pāṇini@pioneers.computer>,"
Blaise,Pascal,M,1642,BlaisePascal@pioneers.computer,"""Blaise Pascal"" <BlaisePascal@pioneers.computer>,"
Judea,Pearl,M,2011,JudeaPearl@pioneers.computer,"""Judea Pearl"" <JudeaPearl@pioneers.computer>,"
Alan,Perlis,M,1952,AlanPerlis@pioneers.computer,"""Alan Perlis"" <AlanPerlis@pioneers.computer>,"
Radia,Perlman,F,1985,RadiaPerlman@pioneers.computer,"""Radia Perlman"" <RadiaPerlman@pioneers.computer>,"
Pier,Perotto,M,1964,PierPerotto@pioneers.computer,"""Pier Perotto"" <PierPerotto@pioneers.computer>,"
Rózsa,Péter,F,1932,RózsaPéter@pioneers.computer,"""Rózsa Péter"" <RózsaPéter@pioneers.computer>,"
Rosalind,Picard,F,1995,RosalindPicard@pioneers.computer,"""Rosalind Picard"" <RosalindPicard@pioneers.computer>,"
Amir,Pnueli,M,1996,AmirPnueli@pioneers.computer,"""Amir Pnueli"" <AmirPnueli@pioneers.computer>,"
Emil,Post,M,1936,EmilPost@pioneers.computer,"""Emil Post"" <EmilPost@pioneers.computer>,"
Michael,Rabin,M,1976,MichaelRabin@pioneers.computer,"""Michael Rabin"" <MichaelRabin@pioneers.computer>,"
Raj,Reddy,M,1994,RajReddy@pioneers.computer,"""Raj Reddy"" <RajReddy@pioneers.computer>,"
Dennis,Ritchie,M,1967,DennisRitchie@pioneers.computer,"""Dennis Ritchie"" <DennisRitchie@pioneers.computer>,"
Ron,Rivest,M,1977,RonRivest@pioneers.computer,"""Ron Rivest"" <RonRivest@pioneers.computer>,"
Saul,Rosen,M,1958,SaulRosen@pioneers.computer,"""Saul Rosen"" <SaulRosen@pioneers.computer>,"
Bertrand,Russell,M,1910,BertrandRussell@pioneers.computer,"""Bertrand Russell"" <BertrandRussell@pioneers.computer>,"
Gerard,Salton,M,1975,GerardSalton@pioneers.computer,"""Gerard Salton"" <GerardSalton@pioneers.computer>,"
Jean,Sammet,F,1962,JeanSammet@pioneers.computer,"""Jean Sammet"" <JeanSammet@pioneers.computer>,"
Charles,Sanders Peirce,M,1880,CharlesSandersPeirce@pioneers.computer,"""Charles Sanders Peirce"" <CharlesSandersPeirce@pioneers.computer>,"
Tadashi,Sasaki,M,1963,TadashiSasaki@pioneers.computer,"""Tadashi Sasaki"" <TadashiSasaki@pioneers.computer>,"
Dana,Scott,M,1976,DanaScott@pioneers.computer,"""Dana Scott"" <DanaScott@pioneers.computer>,"
Adi,Shamir,M,1977,AdiShamir@pioneers.computer,"""Adi Shamir"" <AdiShamir@pioneers.computer>,"
Claude,Shannon,M,1937,ClaudeShannon@pioneers.computer,"""Claude Shannon"" <ClaudeShannon@pioneers.computer>,"
Masatoshi,Shima,M,1968,MasatoshiShima@pioneers.computer,"""Masatoshi Shima"" <MasatoshiShima@pioneers.computer>,"
Joseph,Sifakis,M,2007,JosephSifakis@pioneers.computer,"""Joseph Sifakis"" <JosephSifakis@pioneers.computer>,"
Herbert,Simon,M,1956,HerbertSimon@pioneers.computer,"""Herbert Simon"" <HerbertSimon@pioneers.computer>,"
Karen,Spärck Jones,F,1953,KarenSpärckJones@pioneers.computer,"""Karen Spärck Jones"" <KarenSpärckJones@pioneers.computer>,"
Richard,Stallman,M,1972,RichardStallman@pioneers.computer,"""Richard Stallman"" <RichardStallman@pioneers.computer>,"
Richard,Stearns,M,1993,RichardStearns@pioneers.computer,"""Richard Stearns"" <RichardStearns@pioneers.computer>,"
Michael,Stonebraker,M,1982,MichaelStonebraker@pioneers.computer,"""Michael Stonebraker"" <MichaelStonebraker@pioneers.computer>,"
Bjarne,Stroustrup,M,1979,BjarneStroustrup@pioneers.computer,"""Bjarne Stroustrup"" <BjarneStroustrup@pioneers.computer>,"
Ivan,Sutherland,M,1963,IvanSutherland@pioneers.computer,"""Ivan Sutherland"" <IvanSutherland@pioneers.computer>,"
Robert,Tarjan,M,1986,RobertTarjan@pioneers.computer,"""Robert Tarjan"" <RobertTarjan@pioneers.computer>,"
Charles,Thacker,M,1973,CharlesThacker@pioneers.computer,"""Charles Thacker"" <CharlesThacker@pioneers.computer>,"
André,Thi,M,1972,AndréThi@pioneers.computer,"""André Thi"" <AndréThi@pioneers.computer>,"
Ken,Thompson,M,1967,KenThompson@pioneers.computer,"""Ken Thompson"" <KenThompson@pioneers.computer>,"
Chai-Keong,Toh,M,1993,Chai-KeongToh@pioneers.computer,"""Chai-Keong Toh"" <Chai-KeongToh@pioneers.computer>,"
Leonardo,Torres Quevedo,M,1852,LeonardoTorresQuevedo@pioneers.computer,"""Leonardo Torres Quevedo"" <LeonardoTorresQuevedo@pioneers.computer>,"
Linus,Torvalds,M,1991,LinusTorvalds@pioneers.computer,"""Linus Torvalds"" <LinusTorvalds@pioneers.computer>,"
John,Tukey,M,1965,JohnTukey@pioneers.computer,"""John Tukey"" <JohnTukey@pioneers.computer>,"
Alan,Turing,M,1936,AlanTuring@pioneers.computer,"""Alan Turing"" <AlanTuring@pioneers.computer>,"
Leslie,Valiant,M,2010,LeslieValiant@pioneers.computer,"""Leslie Valiant"" <LeslieValiant@pioneers.computer>,"
Adriaan,van Wijngaarden,M,1968,AdriaanvanWijngaarden@pioneers.computer,"""Adriaan van Wijngaarden"" <AdriaanvanWijngaarden@pioneers.computer>,"
Ramón,Verea,M,1875,RamónVerea@pioneers.computer,"""Ramón Verea"" <RamónVerea@pioneers.computer>,"
John,von Neumann,M,1945,JohnvonNeumann@pioneers.computer,"""John von Neumann"" <JohnvonNeumann@pioneers.computer>,"
An,Wang,M,1950,AnWang@pioneers.computer,"""An Wang"" <AnWang@pioneers.computer>,"
Willis,Ware,M,1955,WillisWare@pioneers.computer,"""Willis Ware"" <WillisWare@pioneers.computer>,"
Maurice,Wilkes,M,1949,MauriceWilkes@pioneers.computer,"""Maurice Wilkes"" <MauriceWilkes@pioneers.computer>,"
James,Wilkinson,M,1970,JamesWilkinson@pioneers.computer,"""James Wilkinson"" <JamesWilkinson@pioneers.computer>,"
Sophie,Wilson,F,1985,SophieWilson@pioneers.computer,"""Sophie Wilson"" <SophieWilson@pioneers.computer>,"
Niklaus,Wirth,M,1970,NiklausWirth@pioneers.computer,"""Niklaus Wirth"" <NiklausWirth@pioneers.computer>,"
Andrew,Yao,M,2000,AndrewYao@pioneers.computer,"""Andrew Yao"" <AndrewYao@pioneers.computer>,"
Konrad,Zuse,M,1938,KonradZuse@pioneers.computer,"""Konrad Zuse"" <KonradZuse@pioneers.computer>,"
```

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql -u mysql -p < src/mysql.sql`</span><br><span style="color:green;">`Enter password: 
`</span>

```
Tables_in_test
pioneers
Field	Type	Null	Key	Default	Extra
first_name	varchar(255)	YES		NULL	
last_name	varchar(255)	NO		NULL	
gender	char(1)	NO		NULL	
first_year	smallint	NO		NULL	
email_school	varchar(255)	NO		NULL	
email_gmail	varchar(255)	NO		NULL	
first_name	last_name	gender	first_year	email_school	email_gmail
Frances	Allen	F	1970	FrancesAllen@pioneers.computer	"Frances Allen" <FrancesAllen@pioneers.computer>,
Kathleen	Booth	F	1947	KathleenBooth@pioneers.computer	"Kathleen Booth" <KathleenBooth@pioneers.computer>,
Lynn	Conway	F	1971	LynnConway@pioneers.computer	"Lynn Conway" <LynnConway@pioneers.computer>,
Elizabeth	Feinler	F	1974	ElizabethFeinler@pioneers.computer	"Elizabeth Feinler" <ElizabethFeinler@pioneers.computer>,
Sally	Floyd	F	1994	SallyFloyd@pioneers.computer	"Sally Floyd" <SallyFloyd@pioneers.computer>,
Shafi	Goldwasser	F	1989	ShafiGoldwasser@pioneers.computer	"Shafi Goldwasser" <ShafiGoldwasser@pioneers.computer>,
Susan	Graham	F	2011	SusanGraham@pioneers.computer	"Susan Graham" <SusanGraham@pioneers.computer>,
Barbara	Grosz	F	1986	BarbaraGrosz@pioneers.computer	"Barbara Grosz" <BarbaraGrosz@pioneers.computer>,
Margaret	Hamilton	F	1971	MargaretHamilton@pioneers.computer	"Margaret Hamilton" <MargaretHamilton@pioneers.computer>,
Betty	Holberton	F	1968	BettyHolberton@pioneers.computer	"Betty Holberton" <BettyHolberton@pioneers.computer>,
Grace	Hopper	F	1952	GraceHopper@pioneers.computer	"Grace Hopper" <GraceHopper@pioneers.computer>,
Barbara	Liskov	F	1987	BarbaraLiskov@pioneers.computer	"Barbara Liskov" <BarbaraLiskov@pioneers.computer>,
Ada	Lovelace	F	1852	AdaLovelace@pioneers.computer	"Ada Lovelace" <AdaLovelace@pioneers.computer>,
Radia	Perlman	F	1985	RadiaPerlman@pioneers.computer	"Radia Perlman" <RadiaPerlman@pioneers.computer>,
Rózsa	Péter	F	1932	RózsaPéter@pioneers.computer	"Rózsa Péter" <RózsaPéter@pioneers.computer>,
Rosalind	Picard	F	1995	RosalindPicard@pioneers.computer	"Rosalind Picard" <RosalindPicard@pioneers.computer>,
Jean	Sammet	F	1962	JeanSammet@pioneers.computer	"Jean Sammet" <JeanSammet@pioneers.computer>,
Karen	Spärck Jones	F	1953	KarenSpärckJones@pioneers.computer	"Karen Spärck Jones" <KarenSpärckJones@pioneers.computer>,
Sophie	Wilson	F	1985	SophieWilson@pioneers.computer	"Sophie Wilson" <SophieWilson@pioneers.computer>,
```

- Read this link to understand how to [export / import](http://zetcode.com/mysql/exportimport/) a selection as [.XML](https://www.w3.org/TR/xml/). For example:

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql -u mysql -p --xml -e 'SELECT * FROM test.pioneers WHERE gender = "F";'`</span><br>
<span style="color:green;">`Enter password :`</span>

```xml
<?xml version="1.0"?>

<resultset statement="SELECT * FROM test.pioneers WHERE gender = &quot;F&quot;" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <row>
	<field name="first_name">Frances</field>
	<field name="last_name">Allen</field>
	<field name="gender">F</field>
	<field name="first_year">1970</field>
	<field name="email_school">FrancesAllen@pioneers.computer</field>
	<field name="email_gmail">&quot;Frances Allen&quot; &lt;FrancesAllen@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Kathleen</field>
	<field name="last_name">Booth</field>
	<field name="gender">F</field>
	<field name="first_year">1947</field>
	<field name="email_school">KathleenBooth@pioneers.computer</field>
	<field name="email_gmail">&quot;Kathleen Booth&quot; &lt;KathleenBooth@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Lynn</field>
	<field name="last_name">Conway</field>
	<field name="gender">F</field>
	<field name="first_year">1971</field>
	<field name="email_school">LynnConway@pioneers.computer</field>
	<field name="email_gmail">&quot;Lynn Conway&quot; &lt;LynnConway@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Elizabeth</field>
	<field name="last_name">Feinler</field>
	<field name="gender">F</field>
	<field name="first_year">1974</field>
	<field name="email_school">ElizabethFeinler@pioneers.computer</field>
	<field name="email_gmail">&quot;Elizabeth Feinler&quot; &lt;ElizabethFeinler@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Sally</field>
	<field name="last_name">Floyd</field>
	<field name="gender">F</field>
	<field name="first_year">1994</field>
	<field name="email_school">SallyFloyd@pioneers.computer</field>
	<field name="email_gmail">&quot;Sally Floyd&quot; &lt;SallyFloyd@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Shafi</field>
	<field name="last_name">Goldwasser</field>
	<field name="gender">F</field>
	<field name="first_year">1989</field>
	<field name="email_school">ShafiGoldwasser@pioneers.computer</field>
	<field name="email_gmail">&quot;Shafi Goldwasser&quot; &lt;ShafiGoldwasser@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Susan</field>
	<field name="last_name">Graham</field>
	<field name="gender">F</field>
	<field name="first_year">2011</field>
	<field name="email_school">SusanGraham@pioneers.computer</field>
	<field name="email_gmail">&quot;Susan Graham&quot; &lt;SusanGraham@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Barbara</field>
	<field name="last_name">Grosz</field>
	<field name="gender">F</field>
	<field name="first_year">1986</field>
	<field name="email_school">BarbaraGrosz@pioneers.computer</field>
	<field name="email_gmail">&quot;Barbara Grosz&quot; &lt;BarbaraGrosz@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Margaret</field>
	<field name="last_name">Hamilton</field>
	<field name="gender">F</field>
	<field name="first_year">1971</field>
	<field name="email_school">MargaretHamilton@pioneers.computer</field>
	<field name="email_gmail">&quot;Margaret Hamilton&quot; &lt;MargaretHamilton@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Betty</field>
	<field name="last_name">Holberton</field>
	<field name="gender">F</field>
	<field name="first_year">1968</field>
	<field name="email_school">BettyHolberton@pioneers.computer</field>
	<field name="email_gmail">&quot;Betty Holberton&quot; &lt;BettyHolberton@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Grace</field>
	<field name="last_name">Hopper</field>
	<field name="gender">F</field>
	<field name="first_year">1952</field>
	<field name="email_school">GraceHopper@pioneers.computer</field>
	<field name="email_gmail">&quot;Grace Hopper&quot; &lt;GraceHopper@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Barbara</field>
	<field name="last_name">Liskov</field>
	<field name="gender">F</field>
	<field name="first_year">1987</field>
	<field name="email_school">BarbaraLiskov@pioneers.computer</field>
	<field name="email_gmail">&quot;Barbara Liskov&quot; &lt;BarbaraLiskov@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Ada</field>
	<field name="last_name">Lovelace</field>
	<field name="gender">F</field>
	<field name="first_year">1852</field>
	<field name="email_school">AdaLovelace@pioneers.computer</field>
	<field name="email_gmail">&quot;Ada Lovelace&quot; &lt;AdaLovelace@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Radia</field>
	<field name="last_name">Perlman</field>
	<field name="gender">F</field>
	<field name="first_year">1985</field>
	<field name="email_school">RadiaPerlman@pioneers.computer</field>
	<field name="email_gmail">&quot;Radia Perlman&quot; &lt;RadiaPerlman@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Rózsa</field>
	<field name="last_name">Péter</field>
	<field name="gender">F</field>
	<field name="first_year">1932</field>
	<field name="email_school">RózsaPéter@pioneers.computer</field>
	<field name="email_gmail">&quot;Rózsa Péter&quot; &lt;RózsaPéter@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Rosalind</field>
	<field name="last_name">Picard</field>
	<field name="gender">F</field>
	<field name="first_year">1995</field>
	<field name="email_school">RosalindPicard@pioneers.computer</field>
	<field name="email_gmail">&quot;Rosalind Picard&quot; &lt;RosalindPicard@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Jean</field>
	<field name="last_name">Sammet</field>
	<field name="gender">F</field>
	<field name="first_year">1962</field>
	<field name="email_school">JeanSammet@pioneers.computer</field>
	<field name="email_gmail">&quot;Jean Sammet&quot; &lt;JeanSammet@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Karen</field>
	<field name="last_name">Spärck Jones</field>
	<field name="gender">F</field>
	<field name="first_year">1953</field>
	<field name="email_school">KarenSpärckJones@pioneers.computer</field>
	<field name="email_gmail">&quot;Karen Spärck Jones&quot; &lt;KarenSpärckJones@pioneers.computer&gt;,</field>
  </row>

  <row>
	<field name="first_name">Sophie</field>
	<field name="last_name">Wilson</field>
	<field name="gender">F</field>
	<field name="first_year">1985</field>
	<field name="email_school">SophieWilson@pioneers.computer</field>
	<field name="email_gmail">&quot;Sophie Wilson&quot; &lt;SophieWilson@pioneers.computer&gt;,</field>
  </row>
</resultset>
```

- To [export / import](http://zetcode.com/mysql/exportimport/) an entire table (in this case, `test.pioneers`) in [.XML](https://www.w3.org/TR/xml/) (in this case, `data/pioneers.xml`), use the following commands:

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`# These commands assume the test database and the pioneers table already exist.`</span><br>
<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql -u mysql -p --xml -e 'SELECT * FROM test.pioneers;'; > data/pioneers.xml`</span><br>
<span style="color:green;">`Enter password :`</span><br>
<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql -u mysql -p test -e 'TRUNCATE pioneers;`</span><br>
<span style="color:green;">`> LOAD XML INFILE "~/work/mysql-example/data/pioneers.xml" INTO TABLE pioneers;'`</span><br>
<span style="color:green;">`Enter password :`</span>

- Read this link to understand how to [`mysqldump`](https://www.tutorialspoint.com/mysql/mysql-database-export.htm) (in text format) and restore an entire database. For example (in this case, `test`):

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysqldump -u mysql -p test > data/test.sql`</span><br>
<span style="color:green;">`Enter password :`</span><br>
<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`mysql -u mysql -p test < ~/work/mysql-example/data/test.sql`</span><br>
<span style="color:green;">`Enter password :`</span>

## Access a MySQL database through Python

- Add the `mysql-connector-python` through [`pip3`](https://pip.pypa.io/en/stable/).

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`pip3 install mysql-connector-python # already installed!`</span>

```
Requirement already satisfied: mysql-connector-python in /usr/local/lib/python3.8/site-packages (8.0.21)
Requirement already satisfied: protobuf>=3.0.0 in /usr/local/Cellar/protobuf/3.12.3/libexec/lib/python3.8/site-packages (from mysql-connector-python) (3.12.3)
Requirement already satisfied: six>=1.9 in /usr/local/Cellar/protobuf/3.12.3/libexec/lib/python3.8/site-packages (from protobuf>=3.0.0->mysql-connector-python) (1.15.0)
Requirement already satisfied: setuptools in /usr/local/lib/python3.8/site-packages (from protobuf>=3.0.0->mysql-connector-python) (49.2.0)
```

- Test [MySQL](https://dev.mysql.com/doc/) access through the following [Python](https://docs.python.org/3/) file.

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`cat src/testmysql.py`</span>

```python
#!/usr/bin/env python3                                                    
#                                                                         
# testmysql.py                                                            
#                                                                         
# pip3 install mysql-connector-python                                     
#                                                                         

import mysql.connector

config = {
    'user': 'mysql',
    'password': 'mysql',
    'host': '127.0.0.1',
    'database': 'test',
}
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()
cursor.execute('SELECT * FROM pioneers WHERE gender = "F";')
for record in cursor:
    print(record)
cnx.close()
```

<span style="color:red;">`dcp:~/work/mysql-example$`</span>
<span style="color:green;">`python3 src/testmysql.py`</span>

```
('Frances', 'Allen', 'F', 1970, 'FrancesAllen@pioneers.computer', '"Frances Allen" <FrancesAllen@pioneers.computer>,')
('Kathleen', 'Booth', 'F', 1947, 'KathleenBooth@pioneers.computer', '"Kathleen Booth" <KathleenBooth@pioneers.computer>,')
('Lynn', 'Conway', 'F', 1971, 'LynnConway@pioneers.computer', '"Lynn Conway" <LynnConway@pioneers.computer>,')
('Elizabeth', 'Feinler', 'F', 1974, 'ElizabethFeinler@pioneers.computer', '"Elizabeth Feinler" <ElizabethFeinler@pioneers.computer>,')
('Sally', 'Floyd', 'F', 1994, 'SallyFloyd@pioneers.computer', '"Sally Floyd" <SallyFloyd@pioneers.computer>,')
('Shafi', 'Goldwasser', 'F', 1989, 'ShafiGoldwasser@pioneers.computer', '"Shafi Goldwasser" <ShafiGoldwasser@pioneers.computer>,')
('Susan', 'Graham', 'F', 2011, 'SusanGraham@pioneers.computer', '"Susan Graham" <SusanGraham@pioneers.computer>,')
('Barbara', 'Grosz', 'F', 1986, 'BarbaraGrosz@pioneers.computer', '"Barbara Grosz" <BarbaraGrosz@pioneers.computer>,')
('Margaret', 'Hamilton', 'F', 1971, 'MargaretHamilton@pioneers.computer', '"Margaret Hamilton" <MargaretHamilton@pioneers.computer>,')
('Betty', 'Holberton', 'F', 1968, 'BettyHolberton@pioneers.computer', '"Betty Holberton" <BettyHolberton@pioneers.computer>,')
('Grace', 'Hopper', 'F', 1952, 'GraceHopper@pioneers.computer', '"Grace Hopper" <GraceHopper@pioneers.computer>,')
('Barbara', 'Liskov', 'F', 1987, 'BarbaraLiskov@pioneers.computer', '"Barbara Liskov" <BarbaraLiskov@pioneers.computer>,')
('Ada', 'Lovelace', 'F', 1852, 'AdaLovelace@pioneers.computer', '"Ada Lovelace" <AdaLovelace@pioneers.computer>,')
('Radia', 'Perlman', 'F', 1985, 'RadiaPerlman@pioneers.computer', '"Radia Perlman" <RadiaPerlman@pioneers.computer>,')
('Rózsa', 'Péter', 'F', 1932, 'RózsaPéter@pioneers.computer', '"Rózsa Péter" <RózsaPéter@pioneers.computer>,')
('Rosalind', 'Picard', 'F', 1995, 'RosalindPicard@pioneers.computer', '"Rosalind Picard" <RosalindPicard@pioneers.computer>,')
('Jean', 'Sammet', 'F', 1962, 'JeanSammet@pioneers.computer', '"Jean Sammet" <JeanSammet@pioneers.computer>,')
('Karen', 'Spärck Jones', 'F', 1953, 'KarenSpärckJones@pioneers.computer', '"Karen Spärck Jones" <KarenSpärckJones@pioneers.computer>,')
('Sophie', 'Wilson', 'F', 1985, 'SophieWilson@pioneers.computer', '"Sophie Wilson" <SophieWilson@pioneers.computer>,')
```

## Notes

- This how-to assumes:
  - [Mac OS](https://en.wikipedia.org/wiki/MacOS_High_Sierra) [Homebrew](https://docs.brew.sh/) is installed (and `brew upgrade python` has been executed to get the latest versions of `python3` and `pip3`). There are many other ways to install [Python](https://docs.python.org/3/) &amp; [MySQL](https://dev.mysql.com/doc/) &mdash; this is just the easiest one.
  - The [`zsh`](https://www.theverge.com/2019/6/4/18651872/apple-macos-catalina-zsh-bash-shell-replacement-features) commands (in <span style="color:green;">green</span>) are executed from <span style="color:red;">`~/work/mysql-example`</span> &mdash; which includes the files:
`README.md` (this file),
`data/pioneers.computer.csv`,
`doc/mysql.pdf`,
`src/mysql.sql`,
`src/testmysql.py`.
- [SQL](https://dev.mysql.com/doc/) can be a bit fussy.
  - By convention, SQL commands are in UPPERCASE, other text is in appropriate mixed case.
  - The `LOAD DATA INFILE '~/work/mysql-example/pioneers.computer.csv' ...` command requires an absolute (glob-pattern) path, the proper line termination (in this case `'\r\n'`), no blank / extra lines, and every field present that is marked ` NOT NULL`.
- Every `SELECT` in this example ends with `WHERE gender = "F"`, *which is not the entire database*. There are 19 women pioneers out of 160 in this database, which limits the output to one ninth of it's potential total length for the purposes of this document.
- The [Python](https://docs.python.org/3/) `mysql.connector` module exists in several versions and it took a bit to find the correct one for Python 3. (Also, *do not name your Python file `mysql.py`* or you will have trouble importing the `mysql` module you expect.)
- *This test is not secure*.
  - The MySQL user `CREATE USER 'mysql'@'localhost' IDENTIFIED BY 'mysql';` with an easy-to-guess password is a terrible idea.
  - Allowing direct local import of data through a `~/.my.cnf` file is good for local testing, but not secure in a deployed system.
  - Having `'password': 'mysql',` as a key:value pair in the Python code is also not a good idea.

Have fun!


<hr>

[&#128279; permalink](https://psb-david-petty.github.io/mysql-example/) and [&#128297; repository](https://github.com/psb-david-petty/mysql-example/) for this page.
