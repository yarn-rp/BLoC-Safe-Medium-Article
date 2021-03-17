# Flutter BLoC Safe 

![Alt text](Frame.jpg?raw=true "Title")

Flutters community is getting bigger everyday. Many native app developers around the world are migrating their projects to Flutter because it's amazing to write one code for "all" cross-platforms solutions. Because of that, the set of apps created with Flutter is getting bigger everyday, and many of them are very complex to build and mantain. So, lets say your Flutter application UI is too complex to handle bussiness logic with StatefullWidget(which is most of the time) and you want to use an state-managment solution to separate your UI layer from your Bussiness-Logic layer, like BLoC.
BLoC is a highly common used pattern for Flutter State Managment. It's a very flexible, elegant and clean solution that mixes Streams, States and Events as classes that gives you the flexibility to pass data and react to it in your data handler. The purpose of this article isn't to explain BLoC, so if you are no proficient on that, please check this link to get a full walkaround on BLoC pattern and Flutter implementation before we continue.

## Crazy "complex" CounterApp 

So lets say we want to achieve a little complex crazy CounterApp with addition and substraction operations. Requirements are the following:

1. CounterApp counter must not be less than 0, so first operation has to be always an addition.

2. We can always make addition, but we can't make substraction if previus operation was a substraction too. If it's not, we will substract floorNumber(1/2 \*(the number of continuous operations of addition). For example, if we push the add button 4 times, the counter is 4, and when we push substract, we will substract by 2, because we made 4 continues addition operations, making the counter equals 2.

## Implementing CounterApp with BLoC 

Let's first implement the BLoC and we will implement the UI later.
With the amazing VS code extension for BLoC, we create our BLoC in a very simple way just doing a right click and selecting the option <Bloc: New Bloc>. After we named it, the extension generates a folder with the following structure:
Let's create first our events:
![Alt text](events.png?raw=true "Title")

CounterBloc Events classes declarationsOur events will be very simple. IncrementCounter will trigger the Addition operation and DecrementCounter will trigger the substraction. We could have added an int field to tell the Bloc the number to operate, but as our logic is to complex to be handle in our UI we decide to move it to the Bloc itself. Now let's move to States classes.
![Alt text](states.png?raw=true "Title")

States will be pretty simple too. We have a CounterInitial state to provide a way to initialize the Bloc with any integer. Then we have a CounterIncremented state and a CounterDecremented state to provide a way to track the previus operation. IncrementedCounter will have an int consecutivesAdditionsOperations to track the consecutives additions operations. Lets now implement the Bloc where we are going to handle events above, do some logic and yield a new State.
![Alt text](bloc.png?raw=true "Title")

In code above we have 2 if. First one will handle the IncrementCounter event. In here we yield a new CounterIncremented state with the counter added by 1 and the currentAditionOperation updated. In the second if we handle the DecrementCounter event. Note that these section of code will only occur if the previus state is a CounterIncremented state. Inside of it we calculate the floor number of the half of of the consecutivesAdditionsOperations and yield a CounterDecremented state with the proper data. I know, it's weird but we are building a crazy "complex" CounterApp!

## Analizing problems of this implementation

The above implementation is a little tricky for reading when actually it's pretty basic. The reason for that is beacause Flutter BLoC doesn't provide an easy way to asilate event handlers, yes…you could separete those codes in separeted functions and it will help, but anyway you have to make the comparison to know which if clause it's going to be executed.

Let's imagine that our CounterApp is much more complex than it is. We could have 10 events, and we could use inheritance on Events to share some data beetween them .Now we are going to have a lot of boilerplate with a lots of ifs, switch or whatever technique you're using to diferentiate events, and we need to handle previus states, so probably inside of those ifs we will have anothers to diferentiate the states. But the main problem of this approach is that code is not exactly deterministic based on the parameters. Let's think we have 3 Events: E1, E2 and E3 where E2 inherits from E1 and E3 inherits from E1 too(This is an approach very used in BLoC to share data beetween Events), and we provide 3 diferent eventHandlers: E1EventHandler, E2EventHandler and E3EventHandler. Code will be something like this:
![Alt text](mapEventToState.png?raw=true "Title")

What will happend if we move the third if clause to the top of the mapEventToState function? Now, as events E2 and E3 are also E1, their specific handlers will never be executed. 
That shouldn't happend right?
As a developer, I'm expecting that my Bussiness Logic Component won't be so susceptible to "move some lines" changes. In the end, we are not changing "real bussiness logic". When we are working at a big company with so many developers, most of the time we are not making a whole component by ourselfs. We work on top of what another guy did, and we are not totally aware about what that guy did, or if the other dev that will work on top of my work , later will be. There most be a secure way to say:

!!! eyyy, if the event is E2, E2EventHandler is its handler, not any other handler!!!

In my reaserch about this topic I found out that Flutter Bloc doesn't provide a explicit way to achieve this idea(at least I didn't founded it or understood how to make it). So I decided to make a flutter package that brigns an easy way to accomplish it.

## Flutter BLoC Safe

Let's say this … I'm not reinventing the wheel. This idea has been with us since the begining of computers with the Turing's machines. If you don't know about Turing's machines or about Deterministic Finite Automaton(DFA) you should give it a read, it will make you fall in love with computers science more than you probably are right now. If you do know about it, it's pretty simple to understand what BLoC Safe is because it's under the same idea of a DFA but taking the best of Flutter BLoC( which i love by the way, don't get me wrong).

## What's BLoC Safe and why I should start using it?

First of all BLoC Safe works literally on top of Flutter Bloc, extending the class and changing some functionality. Thats a decision made mainly to help migration from Flutter Bloc, so yeah, if you sustitute your Bloc for BlocSafe your application will still be intact. You can still use BlocBuilders, BlocConsumers and any other Flutter Bloc widget. With that said, let's talk about the "safer" brother implementation.

Bloc Safe will allow you define deterministic transitions. Instead of the mapEventToState function you need to override, in Bloc Safe you need to override a Map<Edge, Function(Event,State)> buildTransitions function. If you keep overriding mapEventToState function, Bloc Safe will behave exactly like Bloc, no matters if buildTransitions is overriden or not.

Edge is class that recieves two Types, the event Type and the state Type, which will allow us to match a single <event,state> Handler for a every transition of the bloc.
The Function(Event, State) is the function computation for the matching edge.
Lets see an example of this :

![Alt text](bloc_safe_example.png?raw=true "Title")
In this example, that function will only be executed if the event is of type IncrementCounter and the state is of type CounterIncremented. Does this means that I need to provide always the most specific type of the event or the state? The answer is no, we will see this in a second.

If you have inheritance on Events or States, and define a transition for the parent and the child, BlocSafe will take the correct transition no matters the moment you added to buildTransitions map. Lets see an example with the above example of inheritance.
![Alt text](buildTransitions_inheritance_example.png?raw=true "Title")
BlocSafe will take the most specific type for the given event and the currentState, so doesn't matter if someone adds new Events or new States, and change order of transitions, it will still executing the same logic (unless of course someone deletes your transition declaration). Isn't it cool?

## Reflection to get ClassTypes

Now you will be asking youself how can BlocSafe know the most specific type of my event. Well this is done by using reflection to get the ClassType of the event/state instance, so we can match the class that is more especific to data.

## CounterBloc with BlocSafe

So let's see how CounterBloc is implemented using BlocSafe.

I suggest a folder structure like this one:
![Alt text](blocSafe_folder_structure.png?raw=true "Title")

In the file <your_bloc>\_transitions.dart put all your transitions definitions as you do with your events. Declare them as MapEntry's and add them to bloc. Should be something like this:
![Alt text](transition_definitions.png?raw=true "Title")

Then, just get all your transitions and add them to the transitionsBuilderMap.
![Alt text](counter_bloc_safe.png?raw=true "Title")

Finally lets see the results: Javier core la app y has un videito en gif pa q la gnt vea el funcionamiento de esta talla.

## Testing advantages

One of the principal advantages of migrating to BlocSafe is testing. When you make use of TDD, or just make some unit tests over your Bloc component, now you don't have to test that your bloc works properly for your specific case and not for the others cases. Just testing your transitionFunction is enough because you can rely on BlocSafe that's the only transition that's going to me executed for the given <event,state>. Isn't it great?

## Final thoughts

Building a secure, maintainable and scalable application takes a lot of time. BlocSafe is a tool to help you do that in less time and in a more expressive and secure way, much more resistible to future changes. If you like this package don't forget to give it a star.
