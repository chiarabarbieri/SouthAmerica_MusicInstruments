# Cultural macroevolution of musical instruments in South America

<em>Data and scripts</em>

***


This repository contains the data and scripts for the paper "Cultural macroevolution of musical instruments in South America", written by Gabriel Aguirre-Fernandez, Chiara Barbieri, Anna Graff, José Pérez de Arce A., Hyram Moreno and Marcelo Sánchez-Villagra.

The file [testIzikowitz](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/testIzikovitz.r) includes R commands to elaborate the aerophone data from Izikowitz classification [Supplementary Table S2](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/Table_S2_Izikowitz.csv) into a distance matrix, create a Neighbor Joining tree with bootstrap values, display the distribution of different instruments on a continental map, evaluate relationships between different societies by comparinng their similarity in music instruments set and their geographic distances.


***

### Supplementary Tables

* [Supplementary Table S1](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/Table_S1_Sachs%26Hornbostel.xlsx): Classification of instruments according to Hornbostel and Sachs (1914), subsequent revisions and new data for South America. 

* [Supplementary Table S2](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/Table_S2_Izikowitz.csv): Instrument repertoire based on the work of Izikowitz (1935) on ethnographic data, and information on the societies for which the instrument data is found. For each society, the presence/absence of each music instrument is recorded (57 types of instruments in 144 societies or ethnic groups). Character state 1 marks the definite presence of an instrument in the ethnographic record and 0 marks the lack of evidence for a particular instrument. 

* [Supplementary Table S3](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/Table_S3_Panpipes.csv): Data matrix of panpipe profiles. The dataset includes 13 instrument features subdivided in 53 different character states, annotated for 61 societies or ethnic groups.
Features:
1.	Size: 
Small, maximum height less than 10 cm (0); medium, maximum height between 10 cm and 50 cm (1); large, more than 50 cm (2).

2.	Number of rows :
Single (0); double, distal row has open tubes (open at both ends) (1); double, distal row has closed tubes (2).

3.	Parts:
One part (0); two parts, two complementary instruments, or parts of an instrument, are played collectively by two musicians  (1); two parts, two complementary parts of a panpipe are attached by a string (2).

4.	Number of single pipes forming the first row (modified from Izikowitz, 1935. Note: on double panpipes with resonator, the closed row is counted; when both rows are closed e.g., [siku], the greatest number is recorded here):
Less than four (0); four (1); five (2); six (3); seven (4); eight (5); nine to eleven (6); twelve (7); more than twelve (8).

5.	Seriation of pipes :
One series in decreasing order (0); multiple series in consecutive decreasing order (1—rondador); shortest tube in the middle (2); two decreasing series (3); longest in the middle (4); longest on the sides (5).

6.	Ligature kind (inapplicable for clay and stone panpipes):
Guna (0); simple (1); complex ligature thread only(2—chain and possibly campa ligatures); covered in a cloth (3— no ligature); horizontal splint (4); two splints(5); Aymara ligature (6); extensively covered by thread (7); stick between ligature (8); reed (9); similar to Aymara (A).
 
7.	Resin was used either to put tubes together or to cover some tubes (inapplicable for clay and stone panpipes):
No (0); yes (1).
8.	Space is left below the node on the distal part (inapplicable for clay and stone panpipes):
No (0); yes (1).

9.	Indentations on proximal (blowing) ends of panpipes (inapplicable for clay and stone panpipes):
Absent (0); present (1); sharpened end (2); two cuts (3).
10.	Distal profile:
Tubes show externally the same length (0); laddered profile (1); diagonal profile (2).

11.	Some tubes made by more than one culm (inapplicable for clay and stone panpipes):
No (0); yes (1).

12.	Textile art (inapplicable for clay and stone panpipes):
None (0); coloured threads used for binding (1); patterns covering large area of tubes (2).

13.	Feathers attached (inapplicable for clay and stone panpipes):
No (0); yes (1). 

***

![](https://github.com/chiarabarbieri/SouthAmerica_MusicInstruments/blob/main/Fig1_Instruments.jpg)

Fig. 1 Examples of pre-Columbian aerophones in South America (not to scale): a. double-chambered whistling vessel of La Tolita culture (MAAC-2-2857-85); b) ‘snail-chambered’ ceramic globular whistle of the Cuasmal culture (CPS-60); c) conch horn of the Chavín culture (photo JPDA); d) stone panpipe, Tilcara; e) ocarina in the shape of a parrot (Reiss-Engelhorn-Museen-198); f) double-chambered ocarina of La Tolita culture (MAAC-1-2996-87); g) bullroarer from the Apinayé (GM-31.40.266)32; h) wood trumpet of the Chimu culture (Reiss-Engelhorn-Museen-120); i) Mapuche trumpet ‘Nolkin’, played by inhalation; j) Quena made of bone of the Nasca culture (GM-29.32.4h). Figure by Vera Primavera. 
