import 'package:flutter/material.dart';

class RefreshTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const RefreshTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height,
      right: position.right,
      child: SizedBox(
        width: 150,
        child: Text(
          'You can refresh trips here or pull down on the trip list to refresh',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class SleepButtonTutorial extends StatelessWidget {
  const SleepButtonTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 150,
        child: Text(
          'You can change your online/offline status here.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class ProfileTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const ProfileTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + box.size.height,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Profile Button',
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}

class SettingsTutorial extends StatelessWidget {
  final RelativeRect position;
  final RenderBox box;
  const SettingsTutorial({super.key, required this.position, required this.box});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + box.size.height,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Settings Button',
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}

class TripCardTutorial extends StatelessWidget {
  const TripCardTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'Trips can be found here, tapping on this card will show you the details.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TripReferenceCardTutorial extends StatelessWidget {
  const TripReferenceCardTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'Trip references can be found here, tapping on this card will show you the details.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class StopCardTutorial extends StatelessWidget {
  const StopCardTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This is your stop card. You can check in or out here or generate an echeck. Tapping on this card also takes you to the stop details',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TripDetailsTabTutorial extends StatelessWidget {
  const TripDetailsTabTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This tab contains the details of your trip.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class EcheckTabTutorial extends StatelessWidget {
  const EcheckTabTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This tab contains a list of echecks',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class EcheckCardTutorial extends StatelessWidget {
  const EcheckCardTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This represents an e-check. You can cancel the echeck at any time by long pressing on the card or tapping the menu icon in the far right.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class GenerateEcheckButtonTutorial extends StatelessWidget {
  const GenerateEcheckButtonTutorial({super.key, required this.position, required this.box});
  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + 10,
      right: position.right + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'Tapping this button will allow you to generate a new echeck.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TripDocumentsTabTutorial extends StatelessWidget {
  const TripDocumentsTabTutorial({super.key, required this.position, required this.box});

  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + 10,
      right: position.right + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This tab contains your list of trip documents.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TripDocumentsCardTutorial extends StatelessWidget {
  const TripDocumentsCardTutorial({super.key, required this.position, required this.box});

  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top + box.size.height + 10,
      left: position.left + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'This card represents a document associated witht he trip. Tapping on it will display it\'s contents',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TripDocumentUploadButton extends StatelessWidget {
  const TripDocumentUploadButton({super.key, required this.position, required this.box});

  final RelativeRect position;
  final RenderBox box;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.bottom + box.size.height + 10,
      right: position.right + 10,
      child: SizedBox(
        width: 250,
        child: Text(
          'Tapping this button will allow you to upload a new trip document.',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
