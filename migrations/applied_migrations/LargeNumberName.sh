#!/bin/bash

echo ""
echo "Applying migration LargeNumberName"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /largeNumberName                        controllers.LargeNumberNameController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /largeNumberName                        controllers.LargeNumberNameController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeLargeNumberName                  controllers.LargeNumberNameController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeLargeNumberName                  controllers.LargeNumberNameController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "largeNumberName.title = largeNumberName" >> ../conf/messages.en
echo "largeNumberName.heading = largeNumberName" >> ../conf/messages.en
echo "largeNumberName.checkYourAnswersLabel = largeNumberName" >> ../conf/messages.en
echo "largeNumberName.error.required = Enter largeNumberName" >> ../conf/messages.en
echo "largeNumberName.error.length = LargeNumberName must be 100 characters or less" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryLargeNumberNameUserAnswersEntry: Arbitrary[(LargeNumberNamePage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[LargeNumberNamePage.type]";\
    print "        value <- arbitrary[String].suchThat(_.nonEmpty).map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryLargeNumberNamePage: Arbitrary[LargeNumberNamePage.type] =";\
    print "    Arbitrary(LargeNumberNamePage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to UserAnswersGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(LargeNumberNamePage.type, JsValue)] ::";\
    next }1' ../test/generators/UserAnswersGenerator.scala > tmp && mv tmp ../test/generators/UserAnswersGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class CheckYourAnswersHelper/ {\
     print;\
     print "";\
     print "  def largeNumberName: Option[Row] = userAnswers.get(LargeNumberNamePage) map {";\
     print "    answer =>";\
     print "      Row(";\
     print "        key     = Key(msg\"largeNumberName.checkYourAnswersLabel\", classes = Seq(\"govuk-!-width-one-half\")),";\
     print "        value   = Value(lit\"$answer\"),";\
     print "        actions = List(";\
     print "          Action(";\
     print "            content            = msg\"site.edit\",";\
     print "            href               = routes.LargeNumberNameController.onPageLoad(CheckMode).url,";\
     print "            visuallyHiddenText = Some(msg\"site.edit.hidden\".withArgs(msg\"largeNumberName.checkYourAnswersLabel\"))";\
     print "          )";\
     print "        )";\
     print "      )";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration LargeNumberName completed"
