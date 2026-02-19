import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const MainShell(),
    );
  }
}

class AppColors {
  static const background = Color(0xFFF4F6FD);
  static const backgroundSoft = Color(0xFFEFF3FF);
  static const card = Color(0xFFFFFFFF);
  static const cardSoft = Color(0xFFF7F9FF);
  static const textStrong = Color(0xFF11172A);
  static const textNormal = Color(0xFF4E5671);
  static const textSubtle = Color(0xFF8F97B3);
  static const primary = Color(0xFF2F5BFF);
  static const primaryDeep = Color(0xFF1C3DCF);
  static const accentMint = Color(0xFF31C6A8);
  static const divider = Color(0xFFE2E7F6);
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  int _slideDirection = 1;
  bool _isPremium = false;

  void _activatePremium() {
    if (_isPremium) return;
    setState(() => _isPremium = true);
  }

  void _onTabTap(int nextIndex) {
    if (nextIndex == _index) return;
    setState(() {
      _slideDirection = nextIndex > _index ? 1 : -1;
      _index = nextIndex;
    });
  }

  List<Widget> get _screens => [
        HomeScreen(
          isPremium: _isPremium,
          onPremiumPurchased: _activatePremium,
        ),
        const StreakScreen(),
        CustomScreen(
          isPremium: _isPremium,
          onPremiumPurchased: _activatePremium,
        ),
        const ProgressScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppViewport(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder: (currentChild, previousChildren) {
            return currentChild ?? const SizedBox.shrink();
          },
          transitionBuilder: (child, animation) {
            final begin = Offset(0.09 * _slideDirection, 0);
            return ClipRect(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: begin,
                  end: Offset.zero,
                ).animate(animation),
                child: ColoredBox(
                  color: AppColors.background,
                  child: child,
                ),
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_index),
            child: _screens[_index],
          ),
        ),
      ),
      bottomNavigationBar: AppViewport(
        child: _BottomNav(
          index: _index,
          onTap: _onTabTap,
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F4FF)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: Border.all(color: const Color(0xFFE1E7FA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1D26396B),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 82,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TabButton(
                icon: Icons.home_rounded,
                label: 'Home',
                active: index == 0,
                onTap: () => onTap(0),
              ),
              _TabButton(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                active: index == 1,
                onTap: () => onTap(1),
              ),
              _TabButton(
                icon: Icons.grid_view_rounded,
                label: 'Custom',
                active: index == 2,
                onTap: () => onTap(2),
              ),
              _TabButton(
                icon: Icons.crop_portrait_rounded,
                label: 'Progress',
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
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: s.wp(3.3), vertical: s.hp(0.8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: active
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE7EDFF), Color(0xFFDDE6FF)],
                )
              : null,
          border: Border.all(
              color: active ? const Color(0xFFB9C8FF) : Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? AppColors.primary : const Color(0xFFA6AFC9),
            ),
            SizedBox(height: s.hp(0.2)),
            Text(
              label,
              style: TextStyle(
                fontSize: s.sp(10.5),
                fontWeight: FontWeight.w700,
                color: active ? AppColors.primary : const Color(0xFF9BA5C2),
              ),
            ),
          ],
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
  const HomeScreen({
    super.key,
    required this.isPremium,
    required this.onPremiumPurchased,
  });

  final bool isPremium;
  final VoidCallback onPremiumPurchased;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  final _controller = PageController();

  final _challenges = const [
    ChallengeData(
      title: '괄사',
      subtitle: '붓기 케어와 윤곽 정리를 위한\n데일리 루틴',
      days: 30,
      heroColor: Color(0xFF1238F1),
      heroIcon: Icons.account_circle,
      showStartOnDay1: true,
    ),
    ChallengeData(
      title: '스트레칭',
      subtitle: '얼굴과 목 주변 긴장을 풀어주는\n가벼운 루틴',
      days: 30,
      heroColor: Color(0xFF445C58),
      heroIcon: Icons.account_circle,
      showStartOnDay1: false,
    ),
    ChallengeData(
      title: '운동',
      subtitle: '라인 개선을 위한\n집중 트레이닝 루틴',
      days: 30,
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
    final canStartDay1 = challenge.showStartOnDay1 || widget.isPremium;

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
                for (var day = 1; day <= 30; day++) ...[
                  _DayCard(
                    day: day,
                    locked: day == 1 ? !canStartDay1 : !widget.isPremium,
                    showStart: day == 1 && canStartDay1,
                    accent: challenge.heroColor,
                    onLockedTap: () => _showPaywall(
                      context,
                      onPurchased: widget.onPremiumPurchased,
                    ),
                  ),
                  if (day != 30) SizedBox(height: s.hp(1.5)),
                ],
                if (!widget.isPremium)
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
                if (widget.isPremium)
                  Padding(
                    padding: EdgeInsets.only(top: s.hp(0.6), left: s.wp(1.2)),
                    child: Text(
                      '프리미엄 활성화됨: 모든 Day 이용 가능',
                      style: TextStyle(
                        color: const Color(0xFF2F55F3),
                        fontSize: s.sp(12.5),
                        fontWeight: FontWeight.w700,
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
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(data.heroColor, Colors.white, 0.16) ?? data.heroColor,
            data.heroColor,
            Color.lerp(data.heroColor, Colors.black, 0.18) ?? data.heroColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -s.wp(12),
            top: -s.hp(2),
            child: Container(
              width: s.wp(54),
              height: s.wp(54),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x26FFFFFF),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(s.wp(5.5), s.hp(1.6), s.wp(5.5), s.hp(1.8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: s.wp(2.5), vertical: s.hp(0.45)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'AI COACH PICK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: s.sp(10.5),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: s.wp(10.5),
                      height: s.wp(10.5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: s.hp(1.3)),
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: s.sp(28),
                    height: 1.08,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                SizedBox(height: s.hp(0.55)),
                SizedBox(
                  width: s.wp(58),
                  child: Text(
                    data.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: s.sp(13.1),
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: s.hp(1.4)),
                Row(
                  children: [
                    _HeroMetric(
                      label: '진행률',
                      value: '0/${data.days} Days',
                    ),
                    SizedBox(width: s.wp(2.2)),
                    const _HeroMetric(
                      label: '난이도',
                      value: 'Beginner',
                    ),
                  ],
                ),
                SizedBox(height: s.hp(1.5)),
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
            right: s.wp(5),
            bottom: s.hp(1.8),
            child: SizedBox(
              width: s.wp(30),
              height: s.wp(30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: s.wp(28),
                    height: s.wp(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4), width: 2),
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Icon(
                    data.heroIcon,
                    size: s.wp(20),
                    color: Colors.white.withOpacity(0.95),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Container(
              height: s.hp(3.8),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(380, 80)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: s.wp(3), vertical: s.hp(0.7)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: s.sp(10.2),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: s.sp(12.6),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
        color: active ? Colors.white : Colors.white.withOpacity(0.45),
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
    required this.onLockedTap,
  });

  final int day;
  final bool locked;
  final bool showStart;
  final Color accent;
  final VoidCallback onLockedTap;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    final completion = (day / 30).clamp(0, 1).toDouble();
    final cardColor = showStart ? accent : AppColors.card;
    final textColor = showStart ? Colors.white : AppColors.textStrong;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
      shadowColor: accent.withOpacity(0.28),
      elevation: showStart ? 10 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: locked ? onLockedTap : () {},
        child: Padding(
          padding: EdgeInsets.fromLTRB(s.wp(3.6), s.hp(1.35), s.wp(3.6), s.hp(1.45)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: s.wp(11),
                    height: s.wp(11),
                    decoration: BoxDecoration(
                      color: showStart
                          ? Colors.white.withOpacity(0.96)
                          : AppColors.backgroundSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      showStart
                          ? Icons.play_arrow_rounded
                          : (locked ? Icons.lock : Icons.check_rounded),
                      color: showStart
                          ? accent
                          : (locked ? const Color(0xFF1D2033) : AppColors.accentMint),
                      size: s.sp(18),
                    ),
                  ),
                  SizedBox(width: s.wp(3.2)),
                  Text(
                    'Day $day',
                    style: TextStyle(
                      color: textColor,
                      fontSize: s.sp(22),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: s.wp(2)),
                  if (!locked)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: s.wp(1.9), vertical: s.hp(0.25)),
                      decoration: BoxDecoration(
                        color: showStart
                            ? Colors.white.withOpacity(0.24)
                            : const Color(0xFFE7FAF3),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        showStart ? 'TODAY' : 'READY',
                        style: TextStyle(
                          color: showStart ? Colors.white : const Color(0xFF168A62),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          fontSize: s.sp(9.8),
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (showStart)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: s.wp(4.2), vertical: s.hp(0.8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Start',
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
                              color: const Color(0xFFE7EDFF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                                fontSize: s.sp(9.6),
                              ),
                            ),
                          ),
                        ],
                        Icon(
                          Icons.chevron_right_rounded,
                          size: s.sp(24),
                          color: showStart
                              ? Colors.white
                              : const Color(0xFF2A2C3E),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: s.hp(1.05)),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: showStart ? completion : 0,
                  minHeight: 7,
                  backgroundColor: showStart
                      ? Colors.white.withOpacity(0.24)
                      : const Color(0xFFE9EDFA),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    showStart ? Colors.white : accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPaywall(
  BuildContext context, {
  required VoidCallback onPurchased,
}) {
  final s = UIScale.of(context);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF4F7FF)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(s.wp(5.8), s.hp(1), s.wp(5.8), s.hp(2.8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: s.wp(2.4), vertical: s.hp(0.35)),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EDFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'PRO ACCESS',
                  style: TextStyle(
                    color: AppColors.primaryDeep,
                    fontSize: s.sp(10.5),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.45,
                  ),
                ),
              ),
              SizedBox(height: s.hp(0.9)),
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
                '프리미엄 구독 후 Day 2~30, 커스텀 플랜, 리포트 기능까지 이용할 수 있어요.',
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
              Container(
                padding: EdgeInsets.all(s.wp(3.4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    const _PaywallFeatureRow(text: '모든 Day 프로그램 잠금 해제'),
                    SizedBox(height: s.hp(0.55)),
                    const _PaywallFeatureRow(text: '커스텀 플랜 전체 열람'),
                    SizedBox(height: s.hp(0.55)),
                    const _PaywallFeatureRow(text: '기록 화면 이미지 업로드'),
                  ],
                ),
              ),
              SizedBox(height: s.hp(1.8)),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onPurchased();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('결제 완료! 프리미엄이 활성화되었습니다.'),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDeep,
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
            color: const Color(0xFFC8D5F2),
            padding:
                EdgeInsets.fromLTRB(s.wp(5.3), s.hp(1.5), s.wp(5.3), s.hp(2.2)),
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
                SizedBox(height: s.hp(2.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: s.sp(72),
                            height: 1,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDeep,
                            shadows: const [
                              Shadow(
                                color: Color(0x26FFFFFF),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              )
                            ],
                          ),
                        ),
                        Text(
                          'Day streak!',
                          style: TextStyle(
                            fontSize: s.sp(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDeep,
                          ),
                        ),
                      ],
                    ),
                    Text('🔥', style: TextStyle(fontSize: s.sp(74))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  s.wp(5.3), s.hp(2.2), s.wp(5.3), s.hp(3.2)),
              children: [
                Text(
                  'Calendar',
                  style: TextStyle(
                    color: const Color(0xFF808493),
                    fontWeight: FontWeight.w800,
                    fontSize: s.sp(18),
                  ),
                ),
                SizedBox(height: s.hp(1.0)),
                Container(
                  padding: EdgeInsets.all(s.wp(3.5)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFD6D8DF), width: 1.8),
                  ),
                  child: const _MiniCalendar(),
                ),
                SizedBox(height: s.hp(2.4)),
                Text(
                  'Articles',
                  style: TextStyle(
                    color: const Color(0xFF2C2F40),
                    fontWeight: FontWeight.w800,
                    fontSize: s.sp(17),
                  ),
                ),
                SizedBox(height: s.hp(0.95)),
                SizedBox(
                  height: s.hp(26),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _paperCards.length,
                    separatorBuilder: (_, __) => SizedBox(width: s.wp(2.6)),
                    itemBuilder: (context, index) {
                      final paper = _paperCards[index];
                      return _PaperCard(
                        paper: paper,
                        onOpen: () => _openPaper(context, paper.url),
                      );
                    },
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
  const CustomScreen({
    super.key,
    required this.isPremium,
    required this.onPremiumPurchased,
  });

  final bool isPremium;
  final VoidCallback onPremiumPurchased;

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
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: s.hp(1.2)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: s.wp(3.2)),
            padding:
                EdgeInsets.symmetric(horizontal: s.wp(3.8), vertical: s.hp(1.2)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEAF0FF), Color(0xFFDCE6FF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.campaign_rounded,
                    color: AppColors.primaryDeep, size: s.sp(20)),
                SizedBox(width: s.wp(2.2)),
                Expanded(
                  child: Text(
                    '원하는 강도와 부위로 나만의 루틴을 만들어 보세요',
                    style: TextStyle(
                      color: const Color(0xFF334176),
                      fontSize: s.sp(12.2),
                      fontWeight: FontWeight.w700,
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
              children: [
                _PlanCard(
                  isPremium: isPremium,
                  onUnlockTap: () => _showPaywall(
                    context,
                    onPurchased: onPremiumPurchased,
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.isPremium,
    required this.onUnlockTap,
  });

  final bool isPremium;
  final VoidCallback onUnlockTap;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: isPremium ? null : onUnlockTap,
        child: Container(
          padding: EdgeInsets.all(s.wp(4.6)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFF)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.divider, width: 1.6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16243A76),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '30 MINUTES',
                    style: TextStyle(
                      color: AppColors.textSubtle,
                      fontWeight: FontWeight.w800,
                      fontSize: s.sp(12),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isPremium ? Icons.lock_open : Icons.lock,
                    size: s.sp(12),
                    color: const Color(0xFF868996),
                  ),
                  const Spacer(),
                  if (!isPremium) const _TinyPro(),
                  if (isPremium)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: s.wp(2.2), vertical: s.hp(0.35)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F8EE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'UNLOCKED',
                        style: TextStyle(
                          color: const Color(0xFF1C8C4F),
                          fontWeight: FontWeight.w800,
                          fontSize: s.sp(10.2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: s.hp(0.4)),
              Text(
                'Plan 1',
                style: TextStyle(
                  color: const Color(0xFF1B2238),
                  fontWeight: FontWeight.w800,
                  fontSize: s.sp(28),
                ),
              ),
              SizedBox(height: s.hp(1.4)),
              Text(
                '리프팅 + 목선 정렬 + 순환 케어',
                style: TextStyle(
                  color: AppColors.textNormal,
                  fontSize: s.sp(12.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: s.hp(1.2)),
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
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colors[index]),
                    child: Icon(Icons.self_improvement_rounded,
                        size: s.sp(20), color: Colors.white),
                  );
                }),
              ),
              SizedBox(height: s.hp(1.6)),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isPremium ? () {} : onUnlockTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: isPremium
                        ? const Color(0xFF1C8C4F)
                        : AppColors.primaryDeep,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.symmetric(vertical: s.hp(1.4)),
                  ),
                  child: Text(
                    isPremium ? 'Plan 시작하기' : '결제 후 시작하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: s.sp(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaperCardData {
  const PaperCardData({
    required this.title,
    required this.readTime,
    required this.url,
    required this.previewColor,
    required this.previewIcon,
  });

  final String title;
  final String readTime;
  final String url;
  final Color previewColor;
  final IconData previewIcon;
}

const _paperCards = [
  PaperCardData(
    title: 'All about MEWING',
    readTime: '3-minute read',
    url:
        'https://scholar.google.com/scholar?q=facial+exercise+rejuvenation+clinical+trial',
    previewColor: Color(0xFFFDE7A5),
    previewIcon: Icons.question_mark_rounded,
  ),
  PaperCardData(
    title: 'Diet for Jawline',
    readTime: '2-minute read',
    url:
        'https://scholar.google.com/scholar?q=masticatory+muscle+function+anatomy+study',
    previewColor: Color(0xFFDDF3FF),
    previewIcon: Icons.restaurant_menu_rounded,
  ),
  PaperCardData(
    title: 'Neck Posture Basics',
    readTime: '4-minute read',
    url:
        'https://scholar.google.com/scholar?q=forward+head+posture+jaw+muscle+study',
    previewColor: Color(0xFFE7ECFF),
    previewIcon: Icons.accessibility_new_rounded,
  ),
  PaperCardData(
    title: 'Lymphatic Massage',
    readTime: '3-minute read',
    url:
        'https://scholar.google.com/scholar?q=lymphatic+facial+massage+edema+study',
    previewColor: Color(0xFFFDE8E8),
    previewIcon: Icons.spa_rounded,
  ),
  PaperCardData(
    title: 'Skin Elasticity',
    readTime: '5-minute read',
    url:
        'https://scholar.google.com/scholar?q=skin+elasticity+exercise+intervention',
    previewColor: Color(0xFFE8F7ED),
    previewIcon: Icons.auto_awesome_rounded,
  ),
  PaperCardData(
    title: 'Habit Building',
    readTime: '2-minute read',
    url:
        'https://scholar.google.com/scholar?q=habit+formation+adherence+mobile+health+study',
    previewColor: Color(0xFFF8EEFF),
    previewIcon: Icons.track_changes_rounded,
  ),
];

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.paper,
    required this.onOpen,
  });

  final PaperCardData paper;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final s = UIScale.of(context);
    return Container(
      width: s.wp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD3D7E2), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10212F55),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(s.wp(2.9), s.hp(0.9), s.wp(2.9), s.hp(1.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: s.hp(11.8),
            width: double.infinity,
            padding: EdgeInsets.all(s.wp(2.3)),
            decoration: BoxDecoration(
              color: paper.previewColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD1DE), width: 1.3),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                paper.previewIcon,
                size: s.sp(58),
                color: const Color(0xFF2D3F86).withOpacity(0.8),
              ),
            ),
          ),
          SizedBox(height: s.hp(1.2)),
          Text(
            paper.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF212635),
              fontSize: s.sp(14.4),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: s.hp(0.6)),
          Text(
            paper.readTime,
            style: TextStyle(
              color: const Color(0xFF8A90A4),
              fontSize: s.sp(12),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onOpen,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
                elevation: 0,
                minimumSize: Size.fromHeight(s.hp(4.0)),
              ),
              child: Text(
                'Read',
                style: TextStyle(
                  fontSize: s.sp(12.9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openPaper(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (opened || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('링크를 열 수 없습니다.')),
  );
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
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E55EE), Color(0xFF1837AA)],
          ),
        ),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2A0D1F59),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: EdgeInsets.all(s.wp(2.5)),
              child: Column(
                children: [
                  SizedBox(height: s.hp(35), child: const _LockedFrame()),
                  SizedBox(height: s.hp(2.1)),
                  Text(
                    '19 February, 2026',
                    style: TextStyle(
                      color: AppColors.primaryDeep,
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C55F1), Color(0xFF162F8C)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.9), width: 2.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, color: Colors.white, size: s.sp(36)),
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
