# PubKeyExample

Just a basic script in Haskell using Crypto.PubKey and ECDSA
<br>
To build with Cabal :
```
>git clone https://github.com/ProgressiveSweiry/PubKeyExample.git
>cd PubKeyExample
>cabal build
```

<br>
To run executable :

```
>cd dist-newstyle\build\x86_64-windows\ghc-8.10.7\PubKeyExample-0.1.0.0\x\PubKeyExample\build\PubKeyExample
>./PubKeyExample
```

# Examples:


```
>./PubKeyExample
Try -h or --help
```
<br/>

- Display Help:

```
>./PubKeyExample -h
--help To Print This Message
-g To Generate Keys
-m To Sign / Verify Messages
```
<br/>

## Keys Generation

- Generate Keypair

```
>./PubKeyExample -g
Generate [ keypair | private | public ] ?

>keypair
Private Key (Keep Secret) :

001ebf009a3fd7e18d9614a3c7a25709eb9a5881c69c62da7b441dc9268a55b5e74c44ca52402c353ebf2d5747f2fa3f1f2867c6ec584531f3a39888c997e3e745a1

Public Key:

0401442589879907dc27386d946bc48d708d5ec131170de266a1f3ecffe2291ec084d114794ce08f96fb2c5d3f357ebd77542c8fd5bd3de1dd678056333f1eae1b889201665ed92538976c2efedbed188e083be85247a816d33953dc3557794b7387893ee3823761ab8b88babcbb410e43dd79f28ebe6f1b4c41ae1e4f0fbc751b20338f1f
```

<br/>

- Generate (Only) Private Key :

``` 
>./PubKeyExample -g
Generate [ keypair | private | public ] ?

>private
Private Key (Keep Secret):

01c9217d1a95ce547614684b9172a365a3a2fd4584a085e63d297ec9536a50fc3f611f4e15cafd47f9eb99c506a3c31afc512984fb010a5c2b3d83e24b0794eb4e1d
```

<br/>

- Generate Public Key From Existing Private Key (as input) :

```
>./PubKeyExample -g
Generate [ keypair | private | public ] ?

>public
Enter Private Key:

01c9217d1a95ce547614684b9172a365a3a2fd4584a085e63d297ec9536a50fc3f611f4e15cafd47f9eb99c506a3c31afc512984fb010a5c2b3d83e24b0794eb4e1d

Public Key:

0401419660b87fa643ec82707c031f81d21a315249b2ac097f9594ca5f540e9429365696b568e849fe02fdc5f6e98d7e50eb766224449cb25709b5775988eb73b160ae006919c9cf509031f482b1954f11f73a827df05a918a88b2560ba4393255388eb3155480d429c211c08fc3a6ecec7318cd6bc2c4ae0d3db93013bc245f35bdb6fbc3
```

<br/>

# Sign / Verify Message

- Sign Message :

```
> ./PubKeyExample -m
Sign Or Verify Message [ sign | verify ] ?

>sign
Enter Private Key:

>01c9217d1a95ce547614684b9172a365a3a2fd4584a085e63d297ec9536a50fc3f611f4e15cafd47f9eb99c506a3c31afc512984fb010a5c2b3d83e24b0794eb4e1d

Enter Message:

>Hello World

Signature Integers In Order (BOTH NEEDED FOR VERIFICATION):

4661082317664894174143972542394546116521938386550544189879437420622496221893785789432174409743676771067940393135046943577981656308337140487118101317068474381

5137743543735909698783619811430042650315395830589964901196233020474179602859366159354458767332550797576507112755760927101387350219520079647433276471883577720
```

<br/>


- Verify Message : 

```
>./PubKeyExample -m
Sign Or Verify Message [ sign | verify ] ?

>verify
Enter Public Key:

>0401419660b87fa643ec82707c031f81d21a315249b2ac097f9594ca5f540e9429365696b568e849fe02fdc5f6e98d7e50eb766224449cb25709b5775988eb73b160ae006919c9cf509031f482b1954f11f73a827df05a918a88b2560ba4393255388eb3155480d429c211c08fc3a6ecec7318cd6bc2c4ae0d3db93013bc245f35bdb6fbc3

Enter Message:

>Hello World

Enter First Signature Integer:

>4661082317664894174143972542394546116521938386550544189879437420622496221893785789432174409743676771067940393135046943577981656308337140487118101317068474381

Enter Second Signature Integer:

>5137743543735909698783619811430042650315395830589964901196233020474179602859366159354458767332550797576507112755760927101387350219520079647433276471883577720

True
```







