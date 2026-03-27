import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool outlined;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  const AppButton({super.key,required this.label,this.onTap,this.isLoading=false,this.outlined=false,this.color,this.textColor,this.width,this.height=52,this.icon});
  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final fg = textColor ?? AppColors.white;
    return SizedBox(
      width: width ?? double.infinity, height: height,
      child: outlined
        ? OutlinedButton(onPressed: isLoading?null:onTap,
            style: OutlinedButton.styleFrom(foregroundColor:bg,side:BorderSide(color:bg,width:1.5),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))),
            child: _child(bg))
        : ElevatedButton(onPressed: isLoading?null:onTap,
            style: ElevatedButton.styleFrom(backgroundColor:bg,foregroundColor:fg,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),elevation:0),
            child: _child(fg)),
    );
  }
  Widget _child(Color fg) {
    if (isLoading) return SizedBox(width:22,height:22,child:CircularProgressIndicator(strokeWidth:2.5,valueColor:AlwaysStoppedAnimation(fg)));
    if (icon!=null) return Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,size:18),const SizedBox(width:8),Text(label,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w600))]);
    return Text(label,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w600));
  }
}

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  const AppTextField({super.key,required this.label,this.hint,this.controller,this.obscure=false,this.keyboardType=TextInputType.text,this.validator,this.prefixIcon,this.suffix,this.maxLines=1,this.readOnly=false,this.onTap,this.onChanged,this.textInputAction,this.onSubmitted});
  @override State<AppTextField> createState() => _AppTextFieldState();
}
class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  @override void initState(){super.initState();_obscure=widget.obscure;}
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(widget.label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary)),
    const SizedBox(height:8),
    TextFormField(
      controller:widget.controller,obscureText:_obscure,keyboardType:widget.keyboardType,
      validator:widget.validator,maxLines:widget.obscure?1:widget.maxLines,
      readOnly:widget.readOnly,onTap:widget.onTap,onChanged:widget.onChanged,
      textInputAction:widget.textInputAction,onFieldSubmitted:widget.onSubmitted,
      style:const TextStyle(fontSize:14,color:AppColors.textPrimary,fontWeight:FontWeight.w500),
      decoration: InputDecoration(
        hintText:widget.hint??widget.label, prefixIcon:widget.prefixIcon,
        suffixIcon:widget.obscure
          ? IconButton(icon:Icon(_obscure?Icons.visibility_off_outlined:Icons.visibility_outlined,color:AppColors.grey400,size:20),onPressed:()=>setState(()=>_obscure=!_obscure))
          : widget.suffix,
      ),
    ),
  ]);
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key,required this.title,this.action,this.onAction});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
    Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w700,color:AppColors.textPrimary)),
    if(action!=null) GestureDetector(onTap:onAction,child:Text(action!,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.primary))),
  ]);
}

class AppTag extends StatelessWidget {
  final String label;
  final Color? bg;
  final Color? fg;
  final bool selected;
  final VoidCallback? onTap;
  const AppTag({super.key,required this.label,this.bg,this.fg,this.selected=false,this.onTap});
  @override
  Widget build(BuildContext context) {
    final background = selected?AppColors.primary:(bg??AppColors.grey100);
    final foreground = selected?AppColors.white:(fg??AppColors.textSecondary);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),
        decoration:BoxDecoration(color:background,borderRadius:BorderRadius.circular(20),border:selected?null:Border.all(color:AppColors.border)),
        child:Text(label,style:TextStyle(fontSize:13,fontWeight:FontWeight.w500,color:foreground)),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? count;
  const RatingBadge({super.key,required this.rating,this.count});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize:MainAxisSize.min,children:[
    const Icon(Icons.star_rounded,color:Color(0xFFFFA500),size:14),
    const SizedBox(width:3),
    Text(rating.toStringAsFixed(1),style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:AppColors.textPrimary)),
    if(count!=null)...[const SizedBox(width:2),Text('($count)',style:const TextStyle(fontSize:11,color:AppColors.textSecondary))],
  ]);
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({super.key,required this.icon,required this.title,this.subtitle,this.actionLabel,this.onAction});
  @override
  Widget build(BuildContext context) => Center(child:Padding(padding:const EdgeInsets.all(32),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Container(width:80,height:80,decoration:BoxDecoration(color:AppColors.grey100,borderRadius:BorderRadius.circular(40)),child:Icon(icon,size:36,color:AppColors.grey400)),
    const SizedBox(height:20),
    Text(title,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w600,color:AppColors.textPrimary),textAlign:TextAlign.center),
    if(subtitle!=null)...[const SizedBox(height:8),Text(subtitle!,style:const TextStyle(fontSize:13,color:AppColors.textSecondary),textAlign:TextAlign.center)],
    if(actionLabel!=null)...[const SizedBox(height:24),AppButton(label:actionLabel!,onTap:onAction,width:160,height:44)],
  ])));
}

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const ShimmerBox({super.key,this.width=double.infinity,this.height=16,this.radius=8});
  @override State<ShimmerBox> createState() => _ShimmerBoxState();
}
class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override void initState(){super.initState();_ctrl=AnimationController(vsync:this,duration:const Duration(milliseconds:1200))..repeat();_anim=Tween<double>(begin:-1,end:2).animate(CurvedAnimation(parent:_ctrl,curve:Curves.easeInOutSine));}
  @override void dispose(){_ctrl.dispose();super.dispose();}
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation:_anim,builder:(_,__)=>Container(
    width:widget.width,height:widget.height,
    decoration:BoxDecoration(borderRadius:BorderRadius.circular(widget.radius),gradient:LinearGradient(
      begin:Alignment.centerLeft,end:Alignment.centerRight,
      stops:[(_anim.value-1).clamp(0.0,1.0),_anim.value.clamp(0.0,1.0),(_anim.value+1).clamp(0.0,1.0)],
      colors:const[Color(0xFFE8E8E8),Color(0xFFF5F5F5),Color(0xFFE8E8E8)],
    )),
  ));
}

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  const AppNetworkImage({super.key,this.url,this.width,this.height,this.fit=BoxFit.cover,this.borderRadius});
  @override
  Widget build(BuildContext context) {
    final Widget img = (url!=null&&url!.isNotEmpty)
      ? Image.network(url!,width:width,height:height,fit:fit,errorBuilder:(_,__,___)=>_fallback(),loadingBuilder:(_,child,p){if(p==null)return child;return _shimmer();})
      : _fallback();
    return borderRadius!=null?ClipRRect(borderRadius:borderRadius!,child:img):img;
  }
  Widget _fallback()=>Container(width:width,height:height,color:AppColors.grey100,child:const Icon(Icons.image_outlined,color:AppColors.grey300));
  Widget _shimmer()=>ShimmerBox(width:width??double.infinity,height:height??120,radius:0);
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key,required this.status});
  @override
  Widget build(BuildContext context) {
    final (bg,fg) = _colors(status.toLowerCase());
    return Container(
      padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
      decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(20)),
      child:Text(_label(status),style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:fg)),
    );
  }
  String _label(String s)=>s[0].toUpperCase()+s.substring(1).toLowerCase().replaceAll('_',' ');
  (Color,Color) _colors(String s){
    switch(s){
      case'pending':return(const Color(0xFFFFF3CD),const Color(0xFF856404));
      case'accepted':case'processing':return(const Color(0xFFCFE2FF),const Color(0xFF084298));
      case'assigned':case'in_transit':return(const Color(0xFFD1ECF1),const Color(0xFF0C5460));
      case'delivered':case'completed':return(const Color(0xFFD4EDDA),const Color(0xFF155724));
      case'cancelled':return(const Color(0xFFF8D7DA),const Color(0xFF721C24));
      default:return(AppColors.grey100,AppColors.textSecondary);
    }
  }
}
