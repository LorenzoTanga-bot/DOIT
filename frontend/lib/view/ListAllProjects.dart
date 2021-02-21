import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:doit/widget/CardListProject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListAllProjects extends StatefulWidget {
  @override
  _ListAllProjects createState() => _ListAllProjects();
}

class _ListAllProjects extends State<ListAllProjects> {
  final PagingController<int, Project> _pagingController =
      PagingController(firstPageKey: 0);

  _updateUserList(List<Project> projects) {
    Set<String> usersMail = new Set();
    for (Project item in projects) usersMail.add(item.getProjectProposer());
    context.read<UserProvider>().updateListUsers(usersMail.toList());
  }

  _updateTagList(List<Project> project) {
    Set<String> tagId = new Set();
    for (Project item in project) tagId.addAll(item.getTag());
    context.read<TagProvider>().updateListTag(tagId.toList());
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      ProjectsPage newItems =
          await context.read<ProjectProvider>().pageListUser(pageKey);
      _updateUserList(newItems.getListProject());
      _updateTagList(newItems.getListProject());
      if (newItems.isLast()) {
        _pagingController.appendLastPage(newItems.getListProject());
      } else {
        _pagingController.appendPage(newItems.getListProject(), pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, Project>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Project>(
          itemBuilder: (context, item, index) => CardListProject(
            project: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
