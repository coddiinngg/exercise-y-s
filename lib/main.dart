import 'package:flutter/material.dart';

void main() {
  runApp(const JawlineApp());
}

class JawlineApp extends StatelessWidget {
  const JawlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jawline Challenge',
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const MainShell(),
    );
  }
}

class AppColors {
  static const background = Color(0xFFF6F7FB);
  static const card = Color(0xFFF0F1F6);
  static const textStrong = Color(0xFF151729);
  static const textNormal = Color(0xFF505363);
  static const textSubtle = Color(0xFF8E909A);
  static const primary = Color(0xFF3E4DE1);
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    StreakScreen(),
    CustomScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppViewport(child: _screens[_index]),
      bottomNavigationBar: AppViewport(
        child: _BottomNav(
          index: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TabButton(
                icon: Icons.home_rounded,
                active: index == 0,
                onTap: () => onTap(0),
              ),
              _TabButton(
                icon: Icons.local_fire_department_rounded,
                active: index == 1,
                onTap: () => onTap(1),
              ),
              _TabButton(
                icon: Icons.grid_view_rounded,
                active: index == 2,
                onTap: () => onTap(2),
              ),
              _TabButton(
                icon: Icons.crop_portrait_rounded,
                active: index == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 25,
          color: active ? AppColors.primary : const Color(0xFFC9CBD3),
        ),
      ),
    );
  }
}

class ChallengeData {
  const ChallengeData({
    required this.title,
    required this.subtitle,
    required this.days,
    required this.heroColor,
    required this.heroIcon,
    required this.showStartOnDay1,
  });

  final String title;
  final String subtitle;
  final int days;
  final Color heroColor;
  final IconData heroIcon;
  final bool showStartOnDay1;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  final _controller = PageController();

  final _challenges = const [
    ChallengeData(
      title: '60 Days Jawline Challenge',
      subtitle: 'the start of your glow up\njourney',
      days: 60,
      heroColor: Color(0xFF1238F1),
      heroIcon: Icons.account_circle,
      showStartOnDay1: true,
    ),
    ChallengeData(
      title: '30 Days Jawline Challenge',
      subtitle: 'A quick challenge, to get the\nquickest result',
      days: 30,
      heroColor: Color(0xFF445C58),
      heroIcon: Icons.account_circle,
      showStartOnDay1: false,
    ),
    ChallengeData(
      title: '120 Days Jawline Challenge',
      subtitle: 'Made for beasts who can stay\ncommitted',
      days: 120,
      heroColor: Color(0xFFFF1B22),
      heroIcon: Icons.account_circle,
      showStartOnDay1: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    final challenge = _challenges[_current];

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: s.hp(39),
            child: PageView.builder(
              controller: _controller,
              itemCount: _challenges.length,
              onPageChanged: (value) => setState(() => _current = value),
              itemBuilder: (context, index) {
                return _HeroSection(
                  data: _challenges[index],
                  activeIndex: _current,
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: s.wp(5.3), vertical: s.hp(1.1)),
              children: [
                _DayCard(
                  day: 1,
                  locked: !challenge.showStartOnDay1,
                  showStart: challenge.showStartOnDay1,
                  accent: challenge.heroColor,
                ),
                SizedBox(height: s.hp(1.5)),
                for (var day = 2; day <= 4; day++) ...[
                  _DayCard(
                    day: day,
                    locked: true,
                    showStart: false,
                    accent: challenge.heroColor,
                  ),
                  SizedBox(height: s.hp(1.5)),
                ],
                Padding(
                  padding: EdgeInsets.only(top: s.hp(0.6), left: s.wp(1.2)),
                  child: Text(
                    'Day 2부터 프리미엄 구독 후 이용 가능',
                    style: TextStyle(
                      color: AppColors.textSubtle,
                      fontSize: s.sp(12.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.data, required this.activeIndex});

  final ChallengeData data;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(data.heroColor, Colors.white, 0.06) ?? data.heroColor,
            data.heroColor,
            Color.lerp(data.heroColor, Colors.black, 0.08) ?? data.heroColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: s.hp(5.2),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(360, 90)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(s.wp(5.5), s.hp(1.3), s.wp(5.5), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _HeroBubble(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: Color(0xFFF8DA44)),
                    SizedBox(width: 10),
                    _HeroBubble(
                        icon: Icons.landscape_rounded,
                        iconColor: Color(0xFF7362FF)),
                  ],
                ),
                SizedBox(height: s.hp(0.9)),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: s.sp(13.5),
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: s.hp(1.2)),
                SizedBox(
                  width: s.wp(54),
                  child: Text(
                    data.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s.sp(18),
                      height: 1.18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: s.hp(1.2)),
                Text(
                  '0/${data.days} Days Finished',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: s.sp(12.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: s.hp(1.2)),
                Row(
                  children: [
                    _SliderDot(active: activeIndex == 0),
                    const SizedBox(width: 7),
                    _SliderDot(active: activeIndex == 1),
                    const SizedBox(width: 7),
                    _SliderDot(active: activeIndex == 2),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: s.wp(2),
            bottom: s.hp(4.7),
            child: SizedBox(
              width: s.wp(46),
              height: s.wp(46),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: s.wp(38),
                    height: s.wp(38),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  Icon(
                    data.heroIcon,
                    size: s.wp(43),
                    color: Colors.white.withOpacity(0.95),
                  ),
                  Positioned(
                    bottom: s.hp(4),
                    right: s.wp(8),
                    child: Icon(
                      Icons.gesture_rounded,
                      size: s.sp(28),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBubble extends StatelessWidget {
  const _HeroBubble({required this.icon, required this.iconColor});

  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white.withOpacity(0.18),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

class _SliderDot extends StatelessWidget {
  const _SliderDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: active ? 26 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.locked,
    required this.showStart,
    required this.accent,
  });

  final int day;
  final bool locked;
  final bool showStart;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    final cardColor = showStart ? accent : AppColors.card;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      shadowColor: accent.withOpacity(0.28),
      elevation: showStart ? 6 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: locked ? () => _showPaywall(context) : () {},
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: s.wp(3.6), vertical: s.hp(1.7)),
          child: Row(
            children: [
              Container(
                width: s.wp(11),
                height: s.wp(11),
                decoration: BoxDecoration(
                  color: showStart ? Colors.white : const Color(0xFFE4E6EF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  showStart ? Icons.play_arrow_rounded : Icons.lock,
                  color: showStart ? accent : const Color(0xFF1D2033),
                  size: s.sp(18),
                ),
              ),
              SizedBox(width: s.wp(3.4)),
              Text(
                'Day $day',
                style: TextStyle(
                  color: showStart ? Colors.white : AppColors.textStrong,
                  fontSize: s.sp(22),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (showStart)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: s.wp(4.8), vertical: s.hp(0.85)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Start  ▶',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: s.sp(12.8),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    if (locked) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: s.wp(2.2), vertical: s.hp(0.45)),
                        margin: EdgeInsets.only(right: s.wp(2.4)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1E5FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'PRO',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            fontSize: s.sp(10),
                          ),
                        ),
                      ),
                    ],
                    Icon(
                      Icons.chevron_right_rounded,
                      size: s.sp(24),
                      color: const Color(0xFF2A2C3E),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPaywall(BuildContext context) {
  final s = UIScale.of(context);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(s.wp(5.8), s.hp(1), s.wp(5.8), s.hp(2.8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Unlock',
              style: TextStyle(
                fontSize: s.sp(24),
                fontWeight: FontWeight.w800,
                color: AppColors.textStrong,
              ),
            ),
            SizedBox(height: s.hp(0.9)),
            Text(
              '프리미엄 구독 후 Day 2부터 모든 프로그램을 이용할 수 있어요.',
              style: TextStyle(
                fontSize: s.sp(14),
                color: AppColors.textNormal,
                height: 1.35,
              ),
            ),
            SizedBox(height: s.hp(1.6)),
            Row(
              children: [
                const Expanded(
                  child: _PlanOption(
                    title: '월간',
                    price: '₩9,900',
                    active: false,
                  ),
                ),
                SizedBox(width: s.wp(2.6)),
                const Expanded(
                  child: _PlanOption(
                    title: '연간',
                    price: '₩59,000',
                    tag: 'BEST',
                    active: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: s.hp(1.4)),
            const _PaywallFeatureRow(text: '모든 Day 프로그램 잠금 해제'),
            SizedBox(height: s.hp(0.55)),
            const _PaywallFeatureRow(text: '커스텀 플랜 전체 열람'),
            SizedBox(height: s.hp(0.55)),
            const _PaywallFeatureRow(text: '기록 화면 이미지 업로드'),
            SizedBox(height: s.hp(1.8)),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1C3CEF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: s.hp(1.7)),
                ),
                child: Text(
                  '프리미엄 시작',
                  style: TextStyle(
                    fontSize: s.sp(16),
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: s.hp(0.5)),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '나중에',
                  style: TextStyle(
                      fontSize: s.sp(14), color: const Color(0xFF5A5F73)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFCFDCF5),
            padding:
                EdgeInsets.fromLTRB(s.wp(5.3), s.hp(2.2), s.wp(5.3), s.hp(2.5)),
            child: Column(
              children: [
                Text(
                  'Streak',
                  style: TextStyle(
                    fontSize: s.sp(22),
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: s.hp(2.1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: s.sp(64),
                            height: 1,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Day streak!',
                          style: TextStyle(
                            fontSize: s.sp(18),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Text('🔥', style: TextStyle(fontSize: s.sp(62))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  s.wp(5.3), s.hp(1.8), s.wp(5.3), s.hp(1.8)),
              children: [
                Text(
                  'Calendar',
                  style: TextStyle(
                    color: const Color(0xFF878991),
                    fontWeight: FontWeight.w700,
                    fontSize: s.sp(20),
                  ),
                ),
                SizedBox(height: s.hp(1.2)),
                Container(
                  padding: EdgeInsets.all(s.wp(3.5)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border:
                        Border.all(color: const Color(0xFFD5D7DE), width: 2),
                  ),
                  child: const _MiniCalendar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.title,
    required this.price,
    required this.active,
    this.tag,
  });

  final String title;
  final String price;
  final bool active;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: s.wp(3), vertical: s.hp(1.1)),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEFF2FF) : const Color(0xFFF6F7FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? const Color(0xFF9BAAF9) : const Color(0xFFE0E3ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: s.sp(12),
                  color: AppColors.textNormal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (tag != null)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: s.wp(1.8), vertical: s.hp(0.2)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s.sp(9.5),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: s.hp(0.3)),
          Text(
            price,
            style: TextStyle(
              fontSize: s.sp(16),
              color: AppColors.textStrong,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaywallFeatureRow extends StatelessWidget {
  const _PaywallFeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return Row(
      children: [
        Icon(Icons.check_circle_rounded,
            color: const Color(0xFF2F55F3), size: s.sp(16)),
        SizedBox(width: s.wp(2)),
        Text(
          text,
          style: TextStyle(
            fontSize: s.sp(12.5),
            color: const Color(0xFF4E5366),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AppViewport extends StatelessWidget {
  const AppViewport({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 430) return child;
        return ColoredBox(
          color: const Color(0xFFEDEFF6),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar();

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    final days = List.generate(28, (i) => i + 1);

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.chevron_left_rounded,
                color: const Color(0xFF8D9098), size: s.sp(21)),
            const Spacer(),
            Text(
              'February 2026',
              style: TextStyle(
                color: const Color(0xFF232534),
                fontWeight: FontWeight.w800,
                fontSize: s.sp(18),
              ),
            ),
            const Spacer(),
            SizedBox(width: s.sp(21)),
          ],
        ),
        SizedBox(height: s.hp(1.8)),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _WeekLabel('Sun'),
            _WeekLabel('Mon'),
            _WeekLabel('Tue'),
            _WeekLabel('Wed'),
            _WeekLabel('Thu'),
            _WeekLabel('Fri'),
            _WeekLabel('Sat'),
          ],
        ),
        SizedBox(height: s.hp(1.2)),
        GridView.builder(
          itemCount: days.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                '${days[index]}',
                style: TextStyle(
                  color: const Color(0xFF8D8F97),
                  fontSize: s.sp(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeekLabel extends StatelessWidget {
  const _WeekLabel(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: const Color(0xFF9A9DA7),
        fontSize: UIScale.of(context).sp(12),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: s.hp(1.5)),
          Text(
            'Custom',
            style: TextStyle(
              color: AppColors.textStrong,
              fontSize: s.sp(24),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: s.hp(1.7)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: s.wp(3.2)),
            padding:
                EdgeInsets.symmetric(horizontal: s.wp(3.4), vertical: s.hp(1)),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.campaign_rounded,
                    color: const Color(0xFF7181DD), size: s.sp(20)),
                SizedBox(width: s.wp(2.2)),
                Expanded(
                  child: Text(
                    'Create your own training plan like you prefer',
                    style: TextStyle(
                      color: AppColors.textNormal,
                      fontSize: s.sp(11.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: s.hp(1.8)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: s.wp(4.2)),
              children: const [
                _PlanCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard();

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);

    return Container(
      padding: EdgeInsets.all(s.wp(4.6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD0D2DA), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '0 MINUTES',
                style: TextStyle(
                  color: AppColors.textSubtle,
                  fontWeight: FontWeight.w700,
                  fontSize: s.sp(12),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.lock, size: s.sp(12), color: const Color(0xFF868996)),
              const Spacer(),
              const _TinyPro(),
            ],
          ),
          SizedBox(height: s.hp(0.4)),
          Text(
            'Plan 1',
            style: TextStyle(
              color: const Color(0xFF242635),
              fontWeight: FontWeight.w700,
              fontSize: s.sp(28),
            ),
          ),
          SizedBox(height: s.hp(1.4)),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(8, (index) {
              final colors = [
                const Color(0xFFCD92D9),
                const Color(0xFFB8B98F),
                const Color(0xFFA98AE6),
                const Color(0xFFDA95A4),
                const Color(0xFFA8BCDC),
                const Color(0xFFA1725F),
                const Color(0xFFB8B8BA),
                const Color(0xFFD5CFA8),
              ];
              return Container(
                width: s.wp(13),
                height: s.wp(13),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: colors[index]),
                child: Icon(Icons.self_improvement_rounded,
                    size: s.sp(20), color: Colors.white),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TinyPro extends StatelessWidget {
  const _TinyPro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: UIScale.of(context).wp(2.2),
          vertical: UIScale.of(context).hp(0.35)),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E5FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: UIScale.of(context).sp(10.5),
        ),
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);

    return SafeArea(
      child: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            SizedBox(height: s.hp(1.2)),
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: s.sp(23),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: s.hp(2)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: s.wp(5.6)),
              color: Colors.white,
              padding: EdgeInsets.all(s.wp(2.5)),
              child: Column(
                children: [
                  SizedBox(height: s.hp(35), child: const _LockedFrame()),
                  SizedBox(height: s.hp(2.1)),
                  Text(
                    '19 February, 2026',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: s.sp(15.5),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: s.hp(1.4)),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _LockedFrame extends StatelessWidget {
  const _LockedFrame();

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return Container(
      color: AppColors.primary,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: Colors.white, size: s.sp(34)),
              SizedBox(height: s.hp(1.5)),
              Text(
                "Finish Today's exercise to add image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s.sp(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UIScale {
  UIScale._(this._size);

  final Size _size;

  static UIScale of(BuildContext context) {
    return UIScale._(MediaQuery.sizeOf(context));
  }

  double get _wRatio => _size.width / 390;
  double get _hRatio => _size.height / 844;

  double wp(double percent) => _size.width * (percent / 100);
  double hp(double percent) => _size.height * (percent / 100);

  double sp(double value) {
    final scale = (_wRatio * 0.65) + (_hRatio * 0.35);
    return (value * scale).clamp(value * 0.95, value * 1.1);
  }
}
