import 'search_model.dart';
import 'package:flutter/material.dart';
import 'package:huna/secondaryPages/tutor_profile/viewTutorProfile.dart';



class SearchPage extends StatefulWidget {
  final String searchValue;

  const SearchPage({Key key, this.searchValue}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  int _value = 1;
  SearchModel _model = new SearchModel();

  Future initAwait() async {
    await _model.getTutors(widget.searchValue);
  }

  @override

  void initState()  {
    super.initState();
    initAwait();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Search for Tutors'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for Tutors',
                ),
                onSubmitted: (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                textInputAction: TextInputAction.go,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField(
                    value: _value,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text('Ratings : Highest to Lowest'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('Ratings : Lowest to Highest'),
                        value: 2,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 480,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                      ),
                      title: Text('${data[index]['user_firstName']} ${data[index]['user_lastName']}'),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.star,
                              size: 12.0, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 12.0, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 12.0, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 12.0, color: Colors.amber.shade400),
                          Icon(Icons.star, size: 12.0),
                        ],
                      ),
                      trailing: Icon(
                        Icons.favorite,
                        color: Colors.red.shade800,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TutorProfilePage()),
                        );
                      },
                    );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
