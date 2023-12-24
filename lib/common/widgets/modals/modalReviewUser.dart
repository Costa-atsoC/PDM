import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ubi/common/Utils.dart';
import 'package:ubi/firestore/user_firestore.dart';
import '../../../firebase_auth_implementation/models/review_model.dart';
import '../../../firebase_auth_implementation/models/user_model.dart';

class modalReviewUser extends StatefulWidget {
  final UserModel user;
  final String rid;
  const modalReviewUser({required this.user, required this.rid});

  // Method to show the DetailScreen as a modal bottom sheet
  static void show(BuildContext context, UserModel user, String rid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          // Optional: Make the background transparent
          child: modalReviewUser(user: user, rid: rid),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => modalReviewUserState();
}

class modalReviewUserState extends State<modalReviewUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  double rating = 0.0;

  Widget _buildRatingSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildRatingSection(),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(labelText: "Comment"),
                      keyboardType: TextInputType.streetAddress,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Update post data
                          ReviewModel review = ReviewModel(
                            uid: widget.user.uid,
                            rid: widget.rid,
                            rating: rating,
                            date: Utils.currentTimeUser(),
                            comment: _commentController.text
                          );
                          UserFirestore().saveReview(review);

                          Navigator.pop(context); // Close the modal
                          setState(() {});
                        }
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(onPressed: () {Navigator.pop(context);},
                        child: const Text('Cancel')
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }
}
