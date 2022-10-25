; ModuleID = 'sum.ll'
source_filename = "sum.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: norecurse nounwind readonly uwtable
define dso_local i32 @sum(i32* nocapture readonly %0) local_unnamed_addr #0 {
vector.ph:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next.3, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %23, %vector.body ]
  %vec.phi11 = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %24, %vector.body ]
  %1 = getelementptr inbounds i32, i32* %0, i64 %index
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %2, align 4, !tbaa !2
  %3 = getelementptr inbounds i32, i32* %1, i64 4
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.load12 = load <4 x i32>, <4 x i32>* %4, align 4, !tbaa !2
  %5 = add <4 x i32> %wide.load, %vec.phi
  %6 = add <4 x i32> %wide.load12, %vec.phi11
  %index.next = or i64 %index, 8
  %7 = getelementptr inbounds i32, i32* %0, i64 %index.next
  %8 = bitcast i32* %7 to <4 x i32>*
  %wide.load.1 = load <4 x i32>, <4 x i32>* %8, align 4, !tbaa !2
  %9 = getelementptr inbounds i32, i32* %7, i64 4
  %10 = bitcast i32* %9 to <4 x i32>*
  %wide.load12.1 = load <4 x i32>, <4 x i32>* %10, align 4, !tbaa !2
  %11 = add <4 x i32> %wide.load.1, %5
  %12 = add <4 x i32> %wide.load12.1, %6
  %index.next.1 = or i64 %index, 16
  %13 = getelementptr inbounds i32, i32* %0, i64 %index.next.1
  %14 = bitcast i32* %13 to <4 x i32>*
  %wide.load.2 = load <4 x i32>, <4 x i32>* %14, align 4, !tbaa !2
  %15 = getelementptr inbounds i32, i32* %13, i64 4
  %16 = bitcast i32* %15 to <4 x i32>*
  %wide.load12.2 = load <4 x i32>, <4 x i32>* %16, align 4, !tbaa !2
  %17 = add <4 x i32> %wide.load.2, %11
  %18 = add <4 x i32> %wide.load12.2, %12
  %index.next.2 = or i64 %index, 24
  %19 = getelementptr inbounds i32, i32* %0, i64 %index.next.2
  %20 = bitcast i32* %19 to <4 x i32>*
  %wide.load.3 = load <4 x i32>, <4 x i32>* %20, align 4, !tbaa !2
  %21 = getelementptr inbounds i32, i32* %19, i64 4
  %22 = bitcast i32* %21 to <4 x i32>*
  %wide.load12.3 = load <4 x i32>, <4 x i32>* %22, align 4, !tbaa !2
  %23 = add <4 x i32> %wide.load.3, %17
  %24 = add <4 x i32> %wide.load12.3, %18
  %index.next.3 = add nuw nsw i64 %index, 32
  %25 = icmp eq i64 %index.next.3, 1024
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !6

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <4 x i32> %24, %23
  %26 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %bin.rdx)
  ret i32 %26
}

; Function Attrs: nofree nosync nounwind readnone willreturn
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>) #1

attributes #0 = { norecurse nounwind readonly uwtable "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone willreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"Ubuntu clang version 12.0.1-19ubuntu3"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.isvectorized", i32 1}
