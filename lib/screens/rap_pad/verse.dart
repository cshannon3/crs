import 'package:flutter/material.dart';

final List<String> vowels = [
  "~", // a cat
  "@", // aa cake
  "_", // e bed
  "#", // ee keep
  "%", // i sit
  "^", // ii bike
  "<", // o top
  "&", // oo home
  ">", // u sun
  "*", // uu cute
  "/", // other u put
  "=", // oo soon
  "[", // aw dog
  "]", // oi join
  "+" // ow down
];
final List<Color> vowelColors = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.lightGreenAccent,
  Colors.blue,
  Colors.lightBlue,
  Colors.yellow,
  Colors.indigo,
  Colors.purple,
  Colors.deepPurpleAccent,
  Colors.amber,
  Colors.cyan,
  Colors.grey,
  Colors.lightGreenAccent,
  Colors.teal,
];


class Verse {
  final String artistName;
  final String songName;
  final String audioclipAsset;
  final String lyrics;
  final List<String> rhymingvowels;
  bool isReady=false;

  Verse(
      {this.artistName,
      this.songName,
      this.audioclipAsset,
      this.lyrics,
      this.rhymingvowels, this.isReady=false});
}

final List<Verse> testVerses = [

  Verse(
    artistName: "Black Thought",
    songName: "Flex Freestyle",
    audioclipAsset: "black_thought_backagain_2.wav",
    isReady: true,
    lyrics:
        "Pr#e-K~ard~ash%i~an K~any@e,\n M^y rh^yme-pl@ay %imm~ac*ul~ate\n S@ame c@ad~ence ~as D.&O.#C\n Pr#e-~acc%id~ent,\n "
        "M@ayb#e m^y ac*umen &on p~ar w%ith\n K*ool #G  R~ap and them\n G%ive m#e the pr&oper r#espect M&otherf*ucka\n w#e b~ack ag@ain",
    // "Pre-Kardashian Kanye My rhyme-play immaculate Same cadence as D.O.C Pre-accident, Maybe my acumen on par With Kool G  Rap and them Give me the proper respect Mu'f*cka we back again",
    rhymingvowels: [],
  ),

 

  Verse(
    artistName: "Black Thought",
    songName: "Flex Freestyle",
    isReady: true,
    audioclipAsset: "black_thought_soundofthebeast_2.wav",
    lyrics:
        "st_ep R%inse, rep#eat!\n You ch_eckin' for the s+ound of the b#eats\n I am the h+ound,"
        " I am a cr#eep,\n I get d+own, I am a #eat\n I am a k#eep something to l@ay a n@ay-s@ayer to sl#eep\n Pl@aying with h#eat,\n "
        "n&obody and n>oth%ing f>uck%ing w%ith 'R#iq\n Y&o th#ese w#eakl%ings %is cl@aim%ing th@ey c>utt%ing >up %in the str#eet\n N%igg>a p#eace, "
        "yo*u @ain't working with n<oth%ing but the polic#e,\n listen You ain't finna be nothing but the dec#eased,\n "
        "listen You in a turn and him with a permanent cr#ease",
    rhymingvowels: [],
  ),
  Verse(
    artistName: "Black Thought",
    songName: "Flex Freestyle",
    isReady: true,
    audioclipAsset: "black_thought_rapfigures_2.wav",
    lyrics:
        "I str^ike f_ear in the hearts of r~ap f%igures\n Who m^ind b_ear the stigmas of t^ime,\n "
        "no bl~ack pr%ivilege From boom-blap niggas,\n to trap niggas You in the trap with us,\n "
        "where the lions is as Vivid as the walls on the graph\n Or the graph by the Lord of Wrath\n "
        "I reside between the seconds on the chronograph\nHow much more CB4 can we afford?\n"
        "It's like a Sharia law on my My Cherie Amour\n How much hypocrisy can people possibly adore \n"
        "But ain't nobody working on a cure?\n My young boy ",
    rhymingvowels: [],
  ),
  Verse(
    artistName: "Black Thought",
    songName: "Flex Freestyle",
    isReady: true,
    audioclipAsset: "black_thought_nevertheless_2.wav",
    lyrics: "Y'all just r_egul~ar, I am ~a @Ap_ex Pr_ed~at~or\n"
        " Brim st@ay fr_esh, f_eath~ered up, _etc_eter~a N_everth~eless,\n "
        "I got a message and left One dead messenger,\n "
        "yep My pen is Henry Kissinger, Buzz Bissinger\n",
    rhymingvowels: [],
  ),
  
  Verse(
    artistName: "Capital Steez",
    songName: "Free the Robot",
    isReady: true,
    audioclipAsset: "free_the_robot - fastway_2.wav",
    lyrics: "Cause I want mine the f~ast w@ay The ski m~ask w@ay,\n"
        "look%in' for a f~ast p@ay And instead of st%ick%in' >up for each <oth_er \n"
        "We p%ick%in' >up g>uns and st%ick%in' >up our br<oth_ers\n",
    rhymingvowels: [],
  ),
  Verse(
    artistName: "Capital Steez",
    songName: "Free the Robot",
    isReady: true,
    audioclipAsset: "free_the_robot - pushingcrack_2.wav",
    lyrics:
        "No disrespect to the man or the l_eg%end,\n but I'm s%ick and t^ired of ask%in' m^y br_ethr%en \n"
        "if It all _ends %in tw=o thousand #el_ev%en\n W/ould G<od c<ome thr=ough or w/ould h#e actuall#y forg_et >us?\n"
        "Ca>use, apocalypse %is gett%ing cl&os>er\n But they're more focused on our l%il youth s%ipp%in' s&od>a \n"
        "Fuck the s/ug~ar ~act,\n n%igg~as out p/ush%in' cr~ack\n ~And ^I lost m^y f~ather f%igure bec~ause of th~at\n",
    rhymingvowels: [],
  ),
  Verse(
    artistName: "Capital Steez",
    isReady: true,
    songName: "Free the Robot",
    audioclipAsset: "free_the_robot - stevieblind_2.wav",
    lyrics: "Illumin<at#i try^in' to r#ead m^y m^ind with a #eagle ^eye\n"
        "And the haze got m#e thinkin',wh^y W#e killed Osama and plent#y innocent p#eople d^ied\n"
        "W#e should s#ee the s^igns, but w#e St#evi#e bl^ind",
    rhymingvowels: [],
  ),
  Verse(
    artistName: "Capital Steez",
    songName: "Free the Robot",
    isReady: true,
    audioclipAsset: "free_the_robot - thundersound_2.wav",
    lyrics: "So can I live, or is m^y br>other tr^yin' to g>un m#e d+own?\n"
        "Sc>uffle a co>uple of r+ounds 'til w#e hear the th>under s+ound\n"
        "N&o l^ightn%ing, cl~ash of the t^it%ans And ~after the v^iol~ence a m&oment of s^il~ence",
    rhymingvowels: [],
  ),
  
  Verse(
    artistName: "Joey Badass",
    songName: "Paper Trails",
    isReady:  true,
    audioclipAsset: "paper_trails - ipromise_2.wav",
    lyrics:
        "into the ch@amb_er, g_et hyp_erb<ol%ic\nTh@ey r@ais%in' m~ax,\n ^I r@aise st@akes to keep the br<ol%ic"
        " M^y b%itch%es %is m~acroc<osm%ic,\n p~ass the chr<on%ic The m~astered s<on%ics\n %is l%ightyears ab<ove your c<onsc%ious\n"
        "You're n&ov^ice,\n b>ut I g<ot n&otes th~at str^ike nerves\n ^I pr<omise your m^inds ain't sharp l%ike m%y swords ",
    rhymingvowels: [],
  ),


  Verse(
    artistName: "Eminem",
    songName: "Lose Yourself",
    isReady: true,
    audioclipAsset: "lose_yourself - soulsescaping_2.wav",
    lyrics:
        "His s&oul's esc@aping thr*ough this h&ole\n that is g@aping This world is mine for the t@aking,\n"
        " m@ake me king \nAs we m*ove t]oward a New World ]Order\n A n]ormal life is b]oring;\n"
        "but superstardom's Cl&ose to p&ost-m]ortem,\n it &only gr&ows h<arder H&omie gr&ows h<otter,\n"
        " he bl&ows, it's <all &over\n These h&oes is <all on him, c&oast-to-c&oast sh&ows\n "
        "He's kn&own as the Gl&obetr<otter, l&onely r&oads G<od &only kn&ows,\n he's gr&own farther from h&ome, "
        "he's n&o father\n He g&oes h&ome and barely kn&ows his &own daughter\n But h&old your n&ose,"
        " 'cause here g&oes the c&old water These\n h&oes d&on't want him n&o m&o', "
        "he's c&old pro<duct\n They moved on to the next schm&oe who fl&ows\n "
        "He n&ose-d&ove and s&old nada,\n and s&o the s&oap opera Is t&old,\n it unf&olds, "
        "I supp&ose it's &old, partner\n But the beat g&oes on:\n "
        "da-da-dom, da-dom, dah-dah, dah-dah",
    rhymingvowels: [],
  ),



  Verse(
    artistName: "Kendrick Lamar",
    songName: "MAAD City",
    isReady: true,
    audioclipAsset: "maad_city - jumpintheseat_2.wav",
    lyrics: "If I told you I k%illed a n%igga at 16, would you b#eli#eve m#e?\n"
        " Or s#ee m#e to b#e innocent Kendrick that you s#een %in the str#eet\n"
        " With a basketb[all and some Now and Laters to #eat\n"
        " If I m_ention_ed [all of my sk_el_etons, would you jump in the s#eat?\n"
        " Would you s@ay my int_ellig_ence now is gre@at reli#ef?\n"
        "And it's s@afe to s@ay that our n_ext g_ener@ation m@ayb#e can sl#e#ep\n"
        "W%ith dr#eams of b#eing a lawyer or doctor\ ",
    rhymingvowels: [],
  ),

  Verse(
    artistName: "Kendrick Lamar",
    songName: "MAAD City",
    isReady: true,
    audioclipAsset: "maad_city - punk_2.wav",
    lyrics: " W%ith the sliding d&oor, f>uck #is >up? F>uck yo*u sh*oot%in'\n"
        "f&or %if yo>u ain't walk%in >up yo*u f>uckin' p>unk?\n"
        "P%ick%in' >up the f>uck%in' p>ump P%ick%in' [off you s>uckers,\n"
        "s>uck a d%ick &or die &or s>ucker p>unch A w[all >of bullets c>om%in' fr>om",
    rhymingvowels: [],
  ),
];
