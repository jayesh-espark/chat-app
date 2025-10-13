import 'package:chating_app/app/screens/home_screen/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utills/app_images.dart';
import '../../../../core/widgets/common_svg_container.dart';
import '../../../../core/widgets/exit_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(OnPageChangedEvent(pageIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();
        int currentIndex = bloc.currentIndex;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (result, data) async {
            // Prevent back navigation
            if (currentIndex > 0) {
              bloc.add(OnPageChangedEvent(pageIndex: 0));
              return;
            } else {
              // Allow app to close if on the first page
              await showDialog<bool>(
                context: context,
                builder: (_) => const ExitDialog(),
              );
              return;
            }
            return;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: context.read<HomeBloc>().pages[currentIndex],
            bottomNavigationBar: _buildBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                bloc.add(OnPageChangedEvent(pageIndex: index));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar({
    required int currentIndex,
    void Function(int)? onTap,
  }) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,

      items: [
        BottomNavigationBarItem(
          icon: CommonSvgContainer(
            assetName: AppImages.chat,
            color: currentIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: CommonSvgContainer(
            assetName: AppImages.user,
            color: currentIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'User',
        ),
      ],
    );
  }
}
