import 'package:flutter/material.dart';
import 'package:course_project/data/DBHelper.dart';
class ReviewDialog extends StatefulWidget {
  final int propertyId;

  ReviewDialog({required this.propertyId});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить отзыв'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Комментарий',
            ),
          ),
          SizedBox(height: 20),
          Text('Оценка:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 2, 3, 4, 5].map((index) {
              return IconButton(
                icon: Icon(
                  index <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            String comment = _commentController.text.trim(); // Удаляем лишние пробелы

            // Проверяем, был ли введен комментарий
            if (comment.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Пожалуйста, введите комментарий перед добавлением отзыва.')),
              );
              return; // Выходим из метода, чтобы не продолжать выполнение кода
            }

            // Проверяем, была ли выбрана оценка
            if (_rating == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Пожалуйста, выберите оценку перед добавлением отзыва.')),
              );
              return; // Выходим из метода, чтобы не продолжать выполнение кода
            }

            bool isOwner = await DatabaseHelper().checkIfCurrentUserIsOwner(widget.propertyId);

            if (!isOwner) {
              bool hasReview = await DatabaseHelper().checkIfUserHasReview(widget.propertyId);

              if (!hasReview) {
                await DatabaseHelper().saveReview(widget.propertyId, comment, _rating);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Вы уже добавили отзыв к данному объявлению.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Вы не можете добавить отзыв к своему собственному объявлению.')),
              );
            }
          },
          child: Text('Добавить'),
        )


      ],
    );
  }
}