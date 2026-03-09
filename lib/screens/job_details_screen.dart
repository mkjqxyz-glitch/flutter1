import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import 'package:it_career_app/services/app_provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobTitle; 

  const JobDetailsScreen({super.key, required this.jobTitle});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final data = _getLandmarkData(widget.jobTitle);
    final String videoUrl = data['videoUrl'] ?? "https://youtu.be/p-HZX0-rFS8";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? 'p-HZX0-rFS8', 
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnglish => !RegExp(r'[\u0600-\u06FF]').hasMatch(widget.jobTitle);
  String tr(String ar, String en) => _isEnglish ? en : ar;

  // دالة جلب البيانات مع روابط الفيديوهات المخصصة والتعريفات الغنية
  Map<String, dynamic> _getLandmarkData(String title) {
    String key = title;
    if (title.contains("البتراء") || title.contains("Petra")) key = "Petra";
    if (title.contains("وادي رم") || title.contains("Wadi Rum")) key = "WadiRum";
    if (title.contains("البحر الميت") || title.contains("Dead Sea")) key = "DeadSea";
    if (title.contains("جرش") || title.contains("Jerash")) key = "Jerash";
    if (title.contains("عمان") || title.contains("Amman")) key = "Amman";

    switch (key) {
      case "Petra":
        return {
          "videoUrl": "https://youtu.be/jHjLJWByP04?si=l8GS8uDltNYUKpkX",
          "image": "https://images.unsplash.com/photo-1705628078563-966777473473?q=80&w=1169&auto=format&fit=crop",
          "history": tr(
            "تعتبر مدينة البتراء، المنحوتة في الصخر الوردي، واحدة من أعظم الإبداعات البشرية وعاصمة مملكة الأنباط العرب الذين استطاعوا تحويل الصحراء القاحلة إلى واجهة تجارية مزدهرة. تمتاز المدينة بنظام هندسي معقد لجمع المياه وتصريفها، وتجمع عمارتها بين الطراز النبطي الأصيل والفنون الكلاسيكية المتأخرة. إنها ليست مجرد موقع أثري، بل هي رمز للصمود الإنساني وعبقرية التكيف مع البيئة الصعبة، مما جعلها تتبوأ مكانة مرموقة كإحدى عجائب الدنيا السبع الجديدة.",
            "Petra, carved into pink sandstone, is a Nabataean masterpiece and one of the New Seven Wonders. It showcases incredible hydraulic engineering and architectural brilliance."
          ),
          "highlights": tr(
            "• السيق: ممر صخري ضيق بطول 1.2 كم يفتح على الخزنة.\n• الخزنة: الواجهة الأكثر شهرة والمنحوتة بدقة متناهية.\n• الدير (أد دير): أضخم صرح معماري يطل على مناظر بانورامية.\n• المدرج النبطي والمذبح وقصور الملوك.",
            "• The Siq: A natural 1.2km canyon entrance.\n• Al-Khazneh (The Treasury): The iconic rock-cut temple.\n• Ad-Deir (The Monastery): Petra's largest monument."
          ),
          "importance": tr("موقع تراث عالمي لليونسكو منذ 1985 ووجهة سياحية عالمية لا يمكن تفويتها.", "A UNESCO World Heritage site and a global 'must-visit' destination."),
          "location": tr("محافظة معان - جنوب الأردن", "Ma'an Governorate - Southern Jordan")
        };
      case "WadiRum":
        return {
          "videoUrl": "https://youtu.be/55qaBWNimQI?si=6HeoPqiQbf0Jzb-1",
          "image": "https://images.unsplash.com/photo-1558985040-ed4d5029dd50?q=80&w=1173&auto=format&fit=crop",
          "history": tr(
            "وادي رم، المعروف بـ 'وادي القمر'، هو مساحة شاسعة من الصحراء تمتاز بجبالها الرملية الشاهقة وتكويناتها الصخرية الفريدة التي تشبه تضاريس كوكب المريخ. سكنه البشر منذ عصور ما قبل التاريخ، وتركوا بصماتهم على شكل نقوش ورسومات صخرية ثمودية ونبطية. ارتبط الوادي تاريخياً بالثورة العربية الكبرى، وأصبح اليوم وجهة عالمية ليس فقط للسياح، بل لمخرجي أفلام هوليوود الذين يجدون فيه خلفية طبيعية مثالية للأفلام العالمية.",
            "Wadi Rum, the 'Valley of the Moon', is a Mars-like desert famous for its red dunes and soaring peaks. It's a haven for adventurers and filmmakers alike."
          ),
          "highlights": tr(
            "• جبل أم الدامي: أعلى قمة في المملكة الأردنية الهاشمية.\n• خزعلي كانيون: الذي يحتوي على نقوش قديمة لا تقدر بثمن.\n• تجربة المبيت في مخيمات البدو الفلكية تحت ملايين النجوم.\n• رحلات الدفع الرباعي والمناطيد الهوائية.",
            "• Jebel Umm ad Dami: Jordan's highest point.\n• Ancient inscriptions in Khazali Canyon.\n• Luxury stargazing camps and 4x4 desert safaris."
          ),
          "importance": tr("محمية طبيعية عالمية وموقع مدرج على قائمة التراث العالمي لليونسكو.", "A protected nature reserve and a UNESCO World Heritage site."),
          "location": tr("محافظة العقبة - جنوب الأردن", "Aqaba Governorate - Southern Jordan")
        };
      case "DeadSea":
        return {
          "videoUrl": "https://youtu.be/NQH1M18swT0?si=TWiV2R0inq7JxYrK",
          "image": "https://images.unsplash.com/photo-1672417802197-94622fb9d122?q=80&w=1074&auto=format&fit=crop",
          "history": tr(
            "البحر الميت هو أخفض بقعة على وجه الكرة الأرضية، حيث يقع على عمق يزيد عن 430 متراً تحت مستوى سطح البحر. تمتاز مياهه بملوحة شديدة تصل إلى عشرة أضعاف ملوحة المحيطات، مما يمنع الكائنات الحية من العيش فيه، ولكنه يمنح البشر خاصية الطفو الفريدة. تشتهر المنطقة بكونها وجهة علاجية تاريخية، حيث استخدم ملوك قدامى أمثال هيرودوس وكليوباترا طينه الغني بالمعادن وأملاحه للاستشفاء والعناية بالبشرة.",
            "The Dead Sea is the lowest point on Earth. Its hypersaline water allows you to float effortlessly and is famous for its healing properties."
          ),
          "highlights": tr(
            "• تجربة الطفو الطبيعي التي لا تتوفر في أي مكان آخر بالعالم.\n• طين البحر الميت الأسود العلاجي الغني بالمعادن النادرة.\n• المنتجعات الصحية العالمية والمراكز الاستشفائية المتطورة.\n• المناظر الخلابة لغروب الشمس فوق تلال القدس.",
            "• Unique floating experience.\n• Therapeutic black mud treatments.\n• World-class luxury spa resorts."
          ),
          "importance": tr("أكبر مختبر طبيعي وسياحي في العالم وقبلة السياحة العلاجية.", "The world's largest natural spa and a leading health tourism hub."),
          "location": tr("وادي الأردن - وسط المملكة", "Jordan Valley - Central Jordan")
        };
      case "Jerash":
        return {
          "videoUrl": "https://youtu.be/M73K_shc4xA?si=q9UgFAXRCJ25TpLA",
          "image": "https://images.unsplash.com/photo-1671653249911-5dcb983ae917?q=80&w=1170&auto=format&fit=crop",
          "history": tr(
            "تُلقب مدينة جرش بـ 'بومبي الشرق'، وهي بلا شك واحدة من أفضل المدن الرومانية المحفوظة في العالم خارج إيطاليا. تمتاز بتخطيط عمراني روماني كلاسيكي يشمل شوارع مرصوفة ومعبدة بالأعمدة، ومعابد شاهقة فوق التلال، ومسارح ضخمة وساحات عامة وحمامات. تعكس جرش عظمة العصر الذهبي للإمبراطورية الرومانية، ولا تزال ساحاتها ومسارحها تضج بالحياة سنوياً خلال مهرجان جرش للثقافة والفنون.",
            "Jerash, the 'Pompeii of the East', is one of the best-preserved Roman provincial cities globally, featuring grand architecture and ancient streets."
          ),
          "highlights": tr(
            "• ساحة الندوة البيضاوية: الفريدة من نوعها في العالم الروماني.\n• شارع الأعمدة (الكاردو): الممتد بطول 800 متر.\n• المسرح الجنوبي: الذي يمتاز بصوتيات هندسية مذهلة.\n• معبد أرتميس وقوس هادريان العظيم.",
            "• Oval Plaza surrounded by iconic columns.\n• Cardo Maximus (Colonnaded Street).\n• South Theater with perfect acoustics."
          ),
          "importance": tr("تستضيف المهرجان الثقافي الأهم في المنطقة وشاهد حي على الحضارة الرومانية.", "Host of the prestigious annual Jerash Festival for Culture and Arts."),
          "location": tr("محافظة جرش - شمال الأردن", "Jerash Governorate - Northern Jordan")
        };
      case "Amman":
        return {
          "videoUrl": "https://youtu.be/79I8g62APZ0?si=B3k-K-D7c1iF8UYi",
          "image": "https://images.unsplash.com/photo-1630158922952-a92c88afbc4c?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          "history": tr(
            "عمان هي القلب النابض للأردن، وهي مدينة مبنية على تلال عدة، تجمع في نسيجها بين عراقة الماضي وحدثة المستقبل. تعود جذورها إلى العصر الحجري، وقد عرفت في العصر الروماني باسم 'فيلادلفيا'. يتجلى تاريخها العريق في جبل القلعة والمدرج الروماني، بينما تبرز حداثتها في مقاهي جبل عمان ومراكز التسوق العالمية في العبدلي. إنها مدينة ترحب بالجميع، وتمتاز بضيافتها العربية الأصيلة وتنوعها الثقافي الفريد.",
            "Amman is a vibrant city blending ancient history with modern life. Built on hills, it offers historical sites and modern cultural hubs."
          ),
          "highlights": tr(
            "• جبل القلعة: الذي يضم معبد هرقل والقصر الأموي.\n• المدرج الروماني: الذي يتسع لـ 6000 متفرج في قلب العاصمة.\n• وسط البلد (قاع المدينة): حيث الأسواق التقليدية والمأكولات الشعبية.\n• منطقة العبدلي الحديثة وبوليفارد عمان.",
            "• The Citadel: Featuring the Temple of Hercules.\n• Roman Theater: A 6,000-seat ancient arena.\n• Downtown Amman: Traditional markets and street food."
          ),
          "importance": tr("المركز الإداري والثقافي والاقتصادي للمملكة الأردنية الهاشمية.", "The administrative, economic, and cultural capital of Jordan."),
          "location": tr("محافظة العاصمة - وسط المملكة", "Amman Governorate - Central Jordan")
        };
      default:
        return {
          "videoUrl": "https://youtu.be/p-HZX0-rFS8", 
          "image": "https://via.placeholder.com/250", 
          "history": tr("المعلومات سيتم تحديثها قريباً.", "Information will be updated soon."), 
          "highlights": "-", "importance": "-", "location": "-"
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isDark = appProvider.isDarkMode(context);
    final isEn = appProvider.locale.languageCode == 'en';
    
    final data = _getLandmarkData(widget.jobTitle);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F2027) : const Color(0xFFF5F7FA),
      body: Directionality(
        textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.jobTitle, 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                background: Image.network(
                  data['image'] ?? "", 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(tr("مقطع فيديو تعريفي وتعليمي", "Educational Video"), Icons.play_circle_fill, isDark),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: YoutubePlayer(
                        controller: _controller, 
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red, // لون أردني
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildSectionTitle(tr("القيمة التاريخية والثقافية", "Historical & Cultural Value"), Icons.history_edu, isDark),
                    _buildContentCard(data['history'] ?? "", isDark),
                    const SizedBox(height: 25),
                    _buildSectionTitle(tr("أبرز المعالم والتجارب", "Highlights & Experiences"), Icons.explore, isDark),
                    _buildContentCard(data['highlights'] ?? "", isDark),
                    const SizedBox(height: 25),
                    _buildSectionTitle(tr("الأهمية والقيمة السياحية", "Tourism Significance"), Icons.stars_rounded, isDark),
                    _buildContentCard(data['importance'] ?? "", isDark),
                    const SizedBox(height: 25),
                    _buildSectionTitle(tr("الموقع الجغرافي", "Location"), Icons.location_on, isDark),
                    _buildContentCard(data['location'] ?? "", isDark),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildContentCard(String text, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
      ),
      child: Text(text, style: TextStyle(fontSize: 16, height: 1.7, color: isDark ? Colors.white70 : Colors.black87)),
    );
  }
}