

class BottomNavigationbar extends StatefullWidget {
const key ....
@override
State <Stateful Widget> create State() =>_BottomNavigationBarState;
}

class _BottomNavigationBarState extends State< BottomNavigationBar> {
 int current TabIndex = 0;
 final List<Widget> _kTabPages = <Widget> [
  Home(),
  Belanja(),
  Pesan(),

 final List <BottomNavigationBarItem>       _kBottomNavBarItems =     <BottomNavigationBarItems> [
   const BottomNavigationBarItem (icon: Icon  (Icons.item), label: 'Barang'),
   const BottomNavigationBarItem (icon: Icon (Icons.belanja) label: 'Belanja').
   const BottomNavigationBarItem (icon: Icon (Icons.message) label: 'Pesan').

@override
Widget build (BuildContext context) {
final bottomNavBar: BottomNavigationBar(
   items: _kBottomNavBarItems,
   currentIndex: _currentTabIndex,
   type: BottomNavigationBarType.Fixed,
   onTap: (int index) {
      setState ((){
         _currentTabIndex = index;
      });
   },
 );
return Scaffold ( 
   body: _kTabPages [ _currentTabIndex], 
   bottomNavigationBar: bottomNavBar,
 );
}//Widget build C
}//class _BottomNavigationBarState