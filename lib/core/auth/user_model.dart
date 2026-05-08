/// User 数据模型。
///
/// 字段对齐主仓 ADR-0014 (app-auth-existing-jwt) + /api/v1/auth/login 响应：
///   user: { id, email, nickname, avatar_url, membership, member_no, im_user_id }
///
/// 跟姊妹仓 staff 的 Advisor 模型差异：
///   - 没有 display_name / role 字段
///   - 多 nickname / membership / member_no（会员体系字段）
///   - im_user_id 同样由 IM Token 决定，这里只用于 UI 显示
///
/// V1 手写 fromJson；V2 接入 freezed/json_serializable 后切代码生成。
class User {
  const User({
    required this.id,
    required this.email,
    required this.membership,
    this.nickname,
    this.avatarUrl,
    this.memberNo,
    this.imUserId,
  });

  /// sugarark 后端 user.id (UUID)。
  final String id;

  final String email;

  /// 用户昵称（可空：刚注册未设置时）。
  final String? nickname;

  final String? avatarUrl;

  /// 会员等级：free / basic / premium / elite。
  /// V1 用 String 透传；V2 可改 enum + 校验。
  final String membership;

  /// 会员号（M000123 / F000456）。男 daddy = M, 女 baby = F。
  /// V1 仅显示用，规则在后端。
  final String? memberNo;

  /// talkcore IM 侧的 user_id；客户端拿来做发送方对照。
  /// 注意：客户端 *不* 自己传 sender_id，im_user_id 由 IM Token 决定，这里只用于 UI 显示。
  /// 登录响应可能不带（要再调 /im/token 才知道），所以可空。
  final String? imUserId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      membership: (json['membership'] as String?) ?? 'free',
      memberNo: json['member_no'] as String?,
      imUserId: json['im_user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        if (nickname != null) 'nickname': nickname,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'membership': membership,
        if (memberNo != null) 'member_no': memberNo,
        if (imUserId != null) 'im_user_id': imUserId,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.email == email &&
          other.nickname == nickname &&
          other.avatarUrl == avatarUrl &&
          other.membership == membership &&
          other.memberNo == memberNo &&
          other.imUserId == imUserId;

  @override
  int get hashCode => Object.hash(
        id,
        email,
        nickname,
        avatarUrl,
        membership,
        memberNo,
        imUserId,
      );
}
