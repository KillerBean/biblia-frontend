import 'package:biblia/presentation/viewmodels/chapter_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BookPageWidget extends StatefulWidget {
  const BookPageWidget({super.key, required this.bookId});
  final int bookId;

  @override
  State<BookPageWidget> createState() => _BookPageWidgetState();
}

class _BookPageWidgetState extends State<BookPageWidget> {
  final ChapterViewModel viewModel = Modular.get<ChapterViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getChapters(bookId: widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
            onPressed: () => Modular.to.pop(),
            icon: const Icon(CupertinoIcons.return_icon)),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (_, __) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: GridView.builder(
              itemCount: viewModel.numChapters,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (Theme.of(context).platform == TargetPlatform.windows ||
                            Theme.of(context).platform == TargetPlatform.linux ||
                            Theme.of(context).platform == TargetPlatform.macOS)
                        ? 4
                        : 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                mainAxisExtent: 150,
              ),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  Modular.to.pushNamed("/book/${widget.bookId}/${index + 1}");
                },
                child: Center(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 167, 167, 167),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}